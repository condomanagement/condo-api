class CreateWebauthnCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :webauthn_credentials do |t|
      t.references :user, null: false, foreign_key: true
      t.string :external_id, null: false
      t.text :public_key, null: false
      t.bigint :sign_count, null: false, default: 0
      t.string :nickname
      t.string :credential_type, default: "passkey"
      t.text :transports
      t.datetime :last_used_at

      t.timestamps
    end
    add_index :webauthn_credentials, :external_id, unique: true
  end
end
