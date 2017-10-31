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
      # t.date :created_at
      t.boolean :verified
      t.date :verified_at
      # t.object :bank_account
      #   t.string :number
      #   t.string :bank
      #   t.string :type
      # t.object :vehicles
      #   t.text :model
      #   t.text :brand
      #   t.text :photo
      #   t.object :patent
      #     t.bool :verified
      #     t.date :expiration_date
      #     t.string :uri
      #     t.object :data
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
      # t.object :minimun_requirements
      #   t.object :driving_license
      #     t.bool :verified
      #   t.date :expiration_date
      #   t.string :uri
      #   t.json :data
      #   t.object :is_monotributista
      #     t.bool :verified
      #   t.bool :has_cuit_or_cuil
      #   t.bool :has_banking_account
      #   t.bool :has_paypal_account
      # t.object :requirements
      #   t.object :habilitation_transport_food
      #     t.bool :verified
      #   t.object :sanitary_notepad
      #     t.bool :verified
      t.timestamps
    end
  end
end
