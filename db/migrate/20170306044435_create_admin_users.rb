class CreateAdminUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :encrypted_password, null: false, default: ""
      t.string :phone
      t.string :username
      t.string :uid
      t.text :access_key
      t.string :refresh_token
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip



      t.timestamps
    end
    add_index :admin_users, :email,                unique: true
    add_index :admin_users, :reset_password_token, unique: true
 
  end
end
