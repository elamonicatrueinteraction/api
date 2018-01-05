env = ENV['RAILS_ENV'] || Rails.env

ALLOWED_APP_TOKENS = APP_CONFIG[env]['allowed_app_access_tokens'].freeze
ALLOWED_ORIGINS    = APP_CONFIG[env]['allowed_origins'].freeze

HOSTNAME = APP_CONFIG[env]['hostname'].freeze

redis = APP_CONFIG[env]['redis'].freeze
REDIS_DB   = redis['db'].freeze
REDIS_HOST = redis['host'].freeze
REDIS_PORT = redis['port'].freeze
REDIS_URL  = "redis://#{REDIS_HOST}:#{REDIS_PORT}/#{REDIS_DB}".freeze
$redis = Redis.new(host: REDIS_HOST, port: REDIS_PORT)

SHIPPIFY      = APP_CONFIG[env]['shippify'].freeze
SHIPPIFY_API  = SHIPPIFY['api'].freeze
SHIPPIFY_DASH = SHIPPIFY['dash'].freeze

SSL_ENABLED     = APP_CONFIG[env]['ssl_enabled'].freeze
SECURE_PROTOCOL = (SSL_ENABLED ? 'https' : 'http').freeze
