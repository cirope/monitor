class CreateSamls < ActiveRecord::Migration[6.1]
  def change
    create_table :samls do |t|
      t.string :provider, null: false
      t.string :idp_homepage, null: false
      t.string :idp_entity_id, null: false
      t.string :idp_sso_target_url, null: false
      t.string :sp_entity_id, null: false
      t.string :assertion_consumer_service_url, null: false
      t.string :name_identifier_format, null: false
      t.string :assertion_consumer_service_binding, null: false
      t.text :idp_cert, null: false
      t.string :username_attribute, null: false
      t.string :name_attribute, null: false
      t.string :lastname_attribute, null: false
      t.string :email_attribute, null: false
      t.string :roles_attribute, null: false
      t.jsonb :options
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end
