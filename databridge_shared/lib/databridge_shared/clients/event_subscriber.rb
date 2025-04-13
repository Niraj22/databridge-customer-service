# lib/databridge_shared/clients/event_subscriber.rb
require 'databridge_shared/clients/kafka/consumer'

module DataBridgeShared
  module Clients
    class EventSubscriber
      def initialize(broker_config = {})
        @consumer = Kafka::Consumer.new(broker_config)
      end
      
      def subscribe(event_names, handler)
        @consumer.subscribe(event_names, handler)
      end
    end
  end
end