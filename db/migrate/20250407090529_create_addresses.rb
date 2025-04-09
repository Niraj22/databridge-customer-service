class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :address_type, null: false
      t.string :street, null: false
      t.string :city, null: false
      t.string :state
      t.string :postal_code, null: false
      t.string :country, null: false
      t.boolean :is_default, default: false

      t.timestamps
      
      t.index [:customer_id, :address_type, :is_default]
    end
  end
end