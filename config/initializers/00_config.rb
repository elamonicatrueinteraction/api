env = ENV['RAILS_ENV'] || Rails.env

ALLOWED_APP_TOKENS = APP_CONFIG[env]['allowed_app_access_tokens'].freeze
ALLOWED_ORIGINS    = APP_CONFIG[env]['allowed_origins'].freeze

SSL_ENABLED     = APP_CONFIG[env]['ssl_enabled'].freeze
SECURE_PROTOCOL = (SSL_ENABLED ? 'https' : 'http').freeze
