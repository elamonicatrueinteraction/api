module Notifications
  class Notifier

    def initialize(dispatcher: Services::NotificationsService.new)
      @dispatcher = dispatcher
    end

    def notify(builder:)
      body = builder.build
      headers= builder.network_id ? {'X_NETWORK_ID'=> builder.network_id} : {}
      @dispatcher.dispatch(body: body, headers: headers)
    end
  end
end