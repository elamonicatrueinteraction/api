class HealthController < ActionController::API

  VERSION = "1.6.0".freeze

  def health
    is_healthy = is_redis_alive && db_connection_alive
    message = "ERROR"
    message = "Ready. Nilus v#{VERSION}" if is_healthy
    render plain: message, status: :ok
  end

  private

  def is_redis_alive
    begin
      puts "Connecting to Redis..."
      r = Redis.new(host: REDIS_HOST, port: REDIS_PORT)
      r.ping
    rescue Errno::ECONNREFUSED => e
      puts "[Redis]: ERROR - Redis server unavailable"
      false
    end
  end

  def db_connection_alive
    begin
      ActiveRecord::Base.establish_connection # Establishes connection
      ActiveRecord::Base.connection # Calls connection object
      puts "CONNECTED!" if ActiveRecord::Base.connected?
      puts "NOT CONNECTED!" unless ActiveRecord::Base.connected?
      true
    rescue
      puts "NOT CONNECTED!"
      false
    end
  end
end
