# lib/databridge_shared/clients/event_publisher.rb
require 'databridge_shared/clients/kafka/producer'

module DataBridgeShared
  module Clients
    class EventPublisher
      def initialize(broker_config = {})
        @producer = Kafka::Producer.new(broker_config)
      end
      
      def publish(event_name, payload, headers = {})
        @producer.publish(event_name, payload)
      end
      
      def shutdown
        @producer.shutdown
      end
    end
  end
end