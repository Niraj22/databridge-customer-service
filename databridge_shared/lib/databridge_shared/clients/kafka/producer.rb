# lib/databridge_shared/clients/kafka/producer.rb
require 'kafka'
require 'json'

module DataBridgeShared
  module Clients
    module Kafka
      class Producer
        def initialize(config = {})
          seed_brokers = config[:seed_brokers] || ["localhost:9092"]
          client_id = config[:client_id] || "databridge"
          
          @kafka = ::Kafka.new(
            seed_brokers: seed_brokers,
            client_id: client_id
          )
          
          @producer = @kafka.producer(
            required_acks: config[:required_acks] || :all,
            ack_timeout: config[:ack_timeout] || 5,
            retry_backoff: config[:retry_backoff] || 1
          )
          
          Rails.logger.info("Kafka producer initialized with brokers: #{seed_brokers}") if defined?(Rails)
        end
        
        def publish(topic, payload, key = nil)
          json_payload = payload.to_json
          @producer.produce(json_payload, topic: topic, key: key)
          @producer.deliver_messages
          
          if defined?(Rails)
            Rails.logger.info("Published message to topic '#{topic}': #{json_payload[0..100]}...")
          end
        rescue => e
          if defined?(Rails)
            Rails.logger.error("Failed to publish message to topic '#{topic}': #{e.message}")
          end
          raise
        end
        
        def shutdown
          @producer.shutdown
        end
      end
    end
  end
end