class CreateShippers < ActiveRecord::Migration[5.1]
  def change
    create_table :shippers, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :gender
      t.date :birth_date
      t.string :email, null: false
      t.string :phone_num
      t.string :photo
      t.string :cuit
      t.string :cuil
      t.boolean :verified, null: true, default: false
      t.date :verified_at
      t.jsonb :bank_account, null: true, default: bank_account_defaults, index: true, using: :gin
      t.jsonb :vehicles, null: true, default: vehicles_defaults, index: true, using: :gin
      t.string :gateway
      t.string :gateway_id, null: false
      t.jsonb :data, null: true, default: data_defaults, index: true, using: :gin
      t.jsonb :minimum_requirements, null: true, default: minimum_requirements_defaults, index: true, using: :gin
      t.jsonb :requirements, null: true, default: requirements_defaults, index: true, using: :gin
      t.timestamps
    end
  end

  def verified_defaults
    {
      "verified": false,
      "expiration_date": nil,
      "uri": nil,
      "data": nil,
    }
  end

  def bank_account_defaults
    {
      "number": nil,
      "bank": nil,
      "type": nil,
    }
  end

  def vehicles_defaults
    {
      "model": nil,
      "brand": nil,
      "photo": nil,
      "patent": verified_defaults,
      "vehicle_title": verified_defaults,
      "insurance_thirds": verified_defaults,
      "kit_security": verified_defaults,
      "vtv": verified_defaults,
      "free_traffic_ticket": verified_defaults,
      "habilitation_sticker": verified_defaults,
      "air_conditioner": verified_defaults,
    }
  end

  def data_defaults
    {
      "created_at_shippify": nil,
      "enabled_at_shippify": nil,
      "sent_email_invitation_shippify": false,
      "sent_email_instructions": false,
      "comments": nil,
    }
  end

  def minimum_requirements_defaults
    {
      "driving_license": verified_defaults,
      "is_monotributista": verified_defaults,
      "has_cuit_or_cuil": false,
      "has_banking_account": false,
      "has_paypal_account": false,
    }
  end

  def requirements_defaults
    {
      "habilitation_transport_food": verified_defaults,
      "sanitary_notepad": verified_defaults,
    }
  end
end
