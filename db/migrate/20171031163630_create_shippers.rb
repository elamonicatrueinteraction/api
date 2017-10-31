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
      t.boolean :verified
      t.date :verified_at
      t.json :bank_account
      #   t.string :number
      #   t.string :bank
      #   t.string :type
      t.json :vehicles
      #   t.text :model
      #   t.text :brand
      #   t.text :photo
        # t.object :patent
      #   t.bool :patent_verified
      #   t.date :paten_expiration_date
      #   t.string :patent_uri
      #   t.json :patent_data
      #   t.object :vehicle_title
      #   t.object :insurance_thirds
      #   t.object :kit_security
      #   t.object :vtv
      #   t.object :free_traffic_ticket
      #   t.object :habilitation_sticker
      #   t.object :air_conditioner
      t.string :gateway
      t.string :gateway_id
      t.json :data
        # t.date :created_at_shippify
        # t.date :enabled_at_shippify
        # t.boolean :sent_email_invitation_shippify
        # t.boolean :sent_email_instructions
        # t.string :comments
      t.json :minimum_requirements
        # t.object :driving_license
          # t.bool :driving_license_verified
          # t.date :driving_license_expiration_date
          # t.string :driving_license_uri
          # t.json :driving_license_data
        #   t.object :is_monotributista
          # t.date :monotributista_expiration_verified
          # t.date :monotributista_expiration_date
          # t.string :monotributista_uri
          # t.json :monotributista_data

      # t.bool :has_cuit_or_cuil
      # t.bool :has_banking_account
      # t.bool :has_paypal_account
      t.json :requirements
      #   t.object :habilitation_transport_food
        # t.date :habilitation_transport_food_expiration_verified
        # t.date :habilitation_transport_food_expiration_date
        # t.string :habilitation_transport_food_uri
        # t.json :habilitation_transport_food_data
      #   t.object :sanitary_notepad
        # t.date :sanitary_notepad_expiration_verified
        # t.date :sanitary_notepad_expiration_date
        # t.string :sanitary_notepad_uri
        # t.json :sanitary_notepad_data
      t.timestamps
    end
  end
end
