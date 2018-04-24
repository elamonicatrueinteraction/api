module Webhooks
  module Logger
    extend ActiveSupport::Concern

    class_methods do
      def log_notification(*args)
        around_action :webhook_log, only: args
      end
    end

    protected

    def webhook_log
      begin
        yield
      ensure
        Webhook::LogWorker.perform_async(*webhook_log_data)
      end
    end

    private

    def webhook_log_data
      [
        controller_name,
        request.filtered_path,
        parsed_body,
        request.ip,
        request.user_agent,
        notification_datetime
      ]
    end

    def parsed_body
      @parsed_body ||= params.to_unsafe_hash
    end

    def notification_datetime
      @notification_datetime ||= Time.current
    end
  end
end
