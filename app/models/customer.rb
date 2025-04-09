class Customer < ApplicationRecord
  has_secure_password
  
  # Define enums first
  enum role: { customer: 0, admin: 1, staff: 2 }, _suffix: true
  enum status: { active: 0, inactive: 1, suspended: 2 }, _suffix: true
  
  # Associations
  has_many :addresses, dependent: :destroy
  has_many :preferences, dependent: :destroy
  
  # Validations
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, inclusion: { in: roles.keys }  
  validates :status, inclusion: { in: statuses.keys } 
  
  # Callbacks
  after_create :create_default_preferences
  
  # Scopes
  scope :active, -> { where(status: statuses[:active]) }
  scope :by_role, ->(role) { where(role: roles[role]) }
  
  # Methods
  def active?
    status == "active" 
  end
  
  def admin?
    role == "admin"
  end
  
  def default_shipping_address
    addresses.find_by(address_type: 'shipping', is_default: true)
  end
  
  def default_billing_address
    addresses.find_by(address_type: 'billing', is_default: true)
  end
  
  def get_preference(key, default = nil)
    preference = preferences.find_by(key: key)
    preference&.value || default
  end
  
  def set_preference(key, value)
    preference = preferences.find_or_initialize_by(key: key)
    preference.update(value: value)
  end
  
  def publish_created_event
    event_data = {
      id: id,
      email: email,
      name: name,
      created_at: created_at.iso8601
    }
    
    publisher = DataBridgeShared::Clients::EventPublisher.new
    publisher.publish('CustomerCreated', event_data)
  end
  
  def publish_updated_event
    event_data = {
      id: id,
      email: email,
      name: name,
      updated_at: updated_at.iso8601
    }
    
    publisher = DataBridgeShared::Clients::EventPublisher.new
    publisher.publish('CustomerUpdated', event_data)
  end
  
  private
  
  def create_default_preferences
    # Define default preferences for all users
    default_preferences = {
      'email_notifications': 'true',
      'marketing_emails': 'false',
      'two_factor_auth': 'false',
      'theme': 'light',
      'language': 'en',
      'timezone': 'UTC',
      'currency': 'USD'
    }
    
    # Create preferences for each default setting
    default_preferences.each do |key, value|
      preferences.create!(key: key, value: value)
    end
    
    # Log the creation of default preferences
    Rails.logger.info("Created default preferences for customer #{id}")
  end
end