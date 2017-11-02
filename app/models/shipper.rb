class Shipper < ApplicationRecord
  validates_presence_of :first_name, :last_name, :email, :gateway_id
end


# def verified_defaults
#   {
#     "verified": false,
#     "expiration_date": nil,
#     "uri": nil,
#     "data": nil,
#   }
# end

# def bank_account_defaults
#   {
#     "number": nil,
#     "bank": nil,
#     "type": nil,
#   }
# end

# def vehicles_defaults
#   {
#     "model": nil,
#     "brand": nil,
#     "photo": nil,
#     "patent": verified_defaults,
#     "vehicle_title": verified_defaults,
#     "insurance_thirds": verified_defaults,
#     "kit_security": verified_defaults,
#     "vtv": verified_defaults,
#     "free_traffic_ticket": verified_defaults,
#     "habilitation_sticker": verified_defaults,
#     "air_conditioner": verified_defaults,
#   }
# end

# def data_defaults
#   {
#     "created_at_shippify": nil,
#     "enabled_at_shippify": nil,
#     "sent_email_invitation_shippify": false,
#     "sent_email_instructions": false,
#     "comments": nil,
#   }
# end

# def minimum_requirements_defaults
#   {
#     "driving_license": verified_defaults,
#     "is_monotributista": verified_defaults,
#     "has_cuit_or_cuil": false,
#     "has_banking_account": false,
#     "has_paypal_account": false,
#   }
# end

# def requirements_defaults
#   {
#     "habilitation_transport_food": verified_defaults,
#     "sanitary_notepad": verified_defaults,
#   }
# end
