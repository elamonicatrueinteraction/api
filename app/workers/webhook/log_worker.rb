module Webhook
  class LogWorker
    include Sidekiq::Worker

    def perform(service, path, parsed_body, ip, user_agent, requested_at)
      log = WebhookLog.new do |_log|
        _log.service = service
        _log.path = path
        _log.parsed_body = parsed_body
        _log.ip = ip
        _log.user_agent = user_agent
        _log.requested_at = requested_at
      end
      log.save!
    end

  end
end
