module Notifications
  class InstitutionNotifier

    def initialize(tokens,
                   client: FirebasePushNotifier.new)
      @tokens = tokens
      @client = client
    end


    def notify(notification:)
      @client.notify(notification: notification, devices: @tokens)
    end
  end
end
