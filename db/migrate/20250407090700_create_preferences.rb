class CreatePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :preferences do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :key, null: false
      t.text :value

      t.timestamps
      
      t.index [:customer_id, :key], unique: true
    end
  end
end