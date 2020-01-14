module Notifications
  class UnseenNotificationLedger

    def initialize(store: Redis.new(host: REDIS_HOST, port: REDIS_PORT))
      @store = store
    end

    def notification_seen_by(user_id:, notification_id: )
      key = key(user_id: user_id)
      @store.srem(key, notification_id)
    end

    def add_unseen_notification(user_ids: , notification_id: )
      user_ids.map {|id| key(user_id: id)}.each do |user_key|
        @store.sadd(user_key, notification_id)
      end
    end

    def unseen_notifications(user_id:)
      key = key(user_id: user_id)
      unseen = @store.smembers(key)
      unseen ? unseen : []
    end

    private

    def key(user_id:)
      "user:#{user_id}:unseen.notifications"
    end
  end
end
