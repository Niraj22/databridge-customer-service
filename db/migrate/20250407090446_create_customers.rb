class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :email, null: false
      t.string :name
      t.string :password_digest, null: false
      t.integer :role, default: 0, null: false 
      t.integer :status, default: 0, null: false 
      t.datetime :last_login_at

      t.timestamps

      t.index :email, unique: true
    end
  end
end