redis_db   = Rails.application.secrets.redis_db
redis_host = Rails.application.secrets.redis_host
redis_port = Rails.application.secrets.redis_port
redis_url  = "redis://#{redis_host}:#{redis_port}/#{redis_db}".freeze

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, :namespace => 'sk' }

  config.periodic do |mgr|
    # Cada 1 minuto => https://crontab.guru/ for more information
    mgr.register( '0 */1 * * *' , Gateway::PaymentsCheckWorker, queue: 'default')
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, :namespace => 'sk' }
end