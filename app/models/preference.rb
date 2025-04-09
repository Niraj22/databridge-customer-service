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
      
      publisher = DataBridgeShared::Clients::EventPublisher.new
      publisher.publish('CustomerPreferenceChanged', event_data)
    end
  end