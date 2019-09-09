class HealthController < ActionController::API

  VERSION = "1.8.0".freeze

  def health
    is_healthy = is_redis_alive && db_connection_alive
    message = "ERROR"
    message = "Ready. Nilus v#{VERSION}" if is_healthy
    status = is_healthy ? 200 : 500
    render plain: message, status: status
  end

  def ping_async
    Rails.logger.info "[PingAsync] - Starting async ping ..."
    Scheduler::Provider.logistic_scheduler.ping_async
    Rails.logger.info "[PingAsync] - Async ping success ..."
    render plain: "OK", status: :ok
  rescue StandardError => e
    Rails.logger.info "[PingAsync] - Async ping error... #{e}"
    render plain: "ERROR", status: :internal_server_error
  end

  private

  def is_redis_alive
    redis_host = Rails.application.secrets.redis_host
    redis_port = Rails.application.secrets.redis_port
    puts "Connecting to Redis at #{redis_host}:#{redis_port}"
    r = Redis.new(host: redis_host, port: redis_port)
    r.ping
  rescue Errno::ECONNREFUSED => e
    puts "[Redis]: ERROR - Redis server unavailable"
    false
  end

  def db_connection_alive
    ActiveRecord::Base.establish_connection # Establishes connection
    ActiveRecord::Base.connection # Calls connection object
    puts "CONNECTED!" if ActiveRecord::Base.connected?
    puts "DB NOT CONNECTED!" unless ActiveRecord::Base.connected?
    true
  rescue StandardError
    puts "DB NOT CONNECTED!"
    false
  end
end
