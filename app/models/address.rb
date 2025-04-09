
class Address < ApplicationRecord
    # Associations
    belongs_to :customer
    
    # Validations
    validates :address_type, presence: true,
              inclusion: { in: %w[shipping billing] }
    validates :street, :city, :postal_code, :country, presence: true
    
    # Callbacks
    before_save :ensure_single_default, if: :is_default_changed?
    
    # Scopes
    scope :shipping, -> { where(address_type: 'shipping') }
    scope :billing, -> { where(address_type: 'billing') }
    scope :default, -> { where(is_default: true) }
    
    # Methods
    def make_default!
      update(is_default: true)
    end
    
    private
    
    def ensure_single_default
      return unless is_default?
      
      Address.where(customer_id: customer_id, address_type: address_type)
             .where.not(id: id)
             .update_all(is_default: false)
    end
  end