# env = ENV['RAILS_ENV'] || Rails.env
#
# services = NILUS_SERVICES_CONFIG[env].freeze
#
# MARKETPLACE_SERVICE_ENDPOINT = services.dig('marketplace','endpoint').freeze
# MARKETPLACE_SERVICE_TOKEN    = services.dig('marketplace','token').freeze
#
# USER_SERVICE_ENDPOINT = services.dig('user','endpoint').freeze
# USER_SERVICE_TOKEN    = services.dig('user','token').freeze
#
# NILUS_SERVICES_TOKENS = services.each_with_object({}) do |(name, data), _hash|
#   _hash[name] = data['token']
# end
