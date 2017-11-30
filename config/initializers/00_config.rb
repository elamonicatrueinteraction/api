env = ENV['RAILS_ENV'] || Rails.env

ALLOWED_APP_TOKENS = APP_CONFIG[env]['allowed_app_access_tokens'].freeze
ALLOWED_ORIGINS    = APP_CONFIG[env]['allowed_origins'].freeze

HOSTNAME = APP_CONFIG[env]['hostname'].freeze

SHIPPIFY      = APP_CONFIG[env]['shippify'].freeze
SHIPPIFY_API  = SHIPPIFY['api'].freeze
SHIPPIFY_DASH = SHIPPIFY['dash'].freeze

SSL_ENABLED     = APP_CONFIG[env]['ssl_enabled'].freeze
SECURE_PROTOCOL = (SSL_ENABLED ? 'https' : 'http').freeze
