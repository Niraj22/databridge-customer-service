# lib/databridge_shared/clients/kafka/consumer.rb
require 'kafka'
require 'json'

module DataBridgeShared
  module Clients
    module Kafka
      class Consumer
        def initialize(config = {})
          seed_brokers = config[:seed_brokers] || ["localhost:9092"]
          client_id = config[:client_id] || "databridge"
          @consumer_group = config[:consumer_group] || "databridge-group"
          
          @kafka = ::Kafka.new(
            seed_brokers: seed_brokers,
            client_id: client_id
          )
          
          Rails.logger.info("Kafka consumer initialized with brokers: #{seed_brokers}, group: #{@consumer_group}") if defined?(Rails)
        end
        
        def subscribe(topics, handler)
          Array(topics).each do |topic|
            Thread.new do
              begin
                consumer = @kafka.consumer(group_id: @consumer_group)
                consumer.subscribe(topic)
                
                Rails.logger.info("Subscribed to topic: #{topic}") if defined?(Rails)
                
                consumer.each_message do |message|
                  if defined?(Rails)
                    Rails.logger.debug("Received message: topic=#{message.topic}, partition=#{message.partition}, offset=#{message.offset}")
                  end
                  
                  begin
                    payload = JSON.parse(message.value)
                    handler.handle(payload)
                  rescue => e
                    if defined?(Rails)
                      Rails.logger.error("Error processing message: #{e.message}\n#{e.backtrace.join("\n")}")
                    end
                  end
                end
              rescue => e
                if defined?(Rails)
                  Rails.logger.error("Consumer error for topic #{topic}: #{e.message}\n#{e.backtrace.join("\n")}")
                  Rails.logger.info("Restarting consumer for topic #{topic} in 10 seconds...")
                end
                sleep 10
                retry
              ensure
                consumer&.stop
              end
            end
          end
        end
      end
    end
  end
end