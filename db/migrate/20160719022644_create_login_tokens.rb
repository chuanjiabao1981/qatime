class CreateLoginTokens < ActiveRecord::Migration
  def change
    create_table :login_tokens do |t|
      t.references :user, index: true

      t.string :digest_token, limit: 64, index: true
      t.integer :client_type
      t.integer :platform

      t.datetime :expired_at
      t.string :login_ip
      t.datetime :login_at

      t.timestamps null: false
    end
  end
end
