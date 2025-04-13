class Preference < ApplicationRecord
    belongs_to :customer
    
    validates :key, presence: true, uniqueness: { scope: :customer_id }
    
    after_save :publish_preference_changed_event
    
    private
    
    def publish_preference_changed_event
      event_data = {
        customer_id: customer_id,
        key: key,
        updated_at: updated_at.iso8601
      }
      
      begin
        kafka_config = Rails.application.credentials.kafka
        publisher = DataBridgeShared::Clients::EventPublisher.new(
          seed_brokers: kafka_config[:brokers],
          client_id: kafka_config[:client_id]
        )
        
        publisher.publish('CustomerPreferenceChanged', event_data)
        Rails.logger.info "Successfully published CustomerPreferenceChanged event"
      rescue => e
        Rails.logger.error "Failed to publish CustomerPreferenceChanged event: #{e.message}"
      end
    end
  end