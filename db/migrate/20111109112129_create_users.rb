class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :avatar, :default => "http://portraits.kapihospital.de/users/3/3220505bba8933555b772d759d9e83a5_m.png"
      t.integer :level, :default => 1
      t.integer :server
      t.string :av
      t.string :encrypted_password
      t.string :salt
      t.string :remember_token
      t.boolean :admin, :default => false

      t.timestamps
    end
  end
end
