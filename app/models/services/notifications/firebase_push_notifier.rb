module Notifications
  class FirebasePushNotifier

    def initialize(token: Rails.application.secrets.firebase_token)
      @client = FCM.new(token)
      @provider_type = Notifications::Providers::FIREBASE
    end

    def notify(notification:, devices:)
      notification_data = firebase_notification(notification: notification).payload
      @client.send(devices, notification_data)
    end

    private

    def firebase_notification(notification:)
      FirebasePushEvent.new(title: notification["title"], body: notification["body"])
    end
  end

  class FirebasePushEvent
    include ActiveModel::Model

    attr_accessor :title, :body

    def payload
      {
          notification: {
              title: title,
              body: body
          },
          data: {
              title: title,
              body: body,
          }
      }
    end
  end

  module Providers
    FIREBASE = "Firebase"
  end

end