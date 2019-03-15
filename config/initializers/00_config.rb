# env = ENV['RAILS_ENV'] || Rails.env
#
# ALLOWED_APP_TOKENS = APP_CONFIG[env]['allowed_app_access_tokens'].freeze
# ALLOWED_ORIGINS    = APP_CONFIG[env]['allowed_origins'].freeze
#
# aws = APP_CONFIG[env]['aws'].freeze
# AWS_CREDENTIALS = aws['credentials'].freeze
# AWS_REGION      = aws['region'].freeze
# SNS_SETUP       = aws['sns'].freeze
#
# HOSTNAME = APP_CONFIG[env]['hostname'].freeze
#
# MERCADOPAGO        = APP_CONFIG[env]['mercadopago'].freeze
# MERCADOPAGO_CONFIG = MERCADOPAGO['config'].freeze
#
# redis = APP_CONFIG[env]['redis'].freeze
redis_db   = Rails.application.secrets.redis_db
redis_host = Rails.application.secrets.redis_host
redis_port = Rails.application.secrets.redis_port
redis_url  = "redis://#{redis_host}:#{redis_port}/#{redis_db}".freeze
$redis = Redis.new(host: redis_host, port: redis_port)
#
# services = APP_CONFIG[env]['services'].freeze
# SERVICES_TOKENS = services.each_with_object({}) do |(name, data), _hash|
#   _hash[name] = data['token']
# end
# MARKETPLACE_API_ENDPOINT = APP_CONFIG[env]['services']['marketplace']['endpoint']
# MARKETPLACE_API_TOKEN = APP_CONFIG[env]['services']['marketplace']['token']
#
# ROLLBAR_ACCESS_TOKEN  = APP_CONFIG[env]['rollbar']['access_token'].freeze
#
# STAGING         = APP_CONFIG[env]['staging'].freeze || false
#
# SSL_ENABLED     = APP_CONFIG[env]['ssl_enabled'].freeze
# SECURE_PROTOCOL = (SSL_ENABLED ? 'https' : 'http').freeze
