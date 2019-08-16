module Scheduler
  class ActionScheduler

    def initialize(action:)
      @action = action
    end

    def cancel_remote_payment_async(payment)
      @action.call(payment)
    end
  end
end