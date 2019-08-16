module Scheduler
  class FakeScheduler

    attr_reader :times

    def initialize
      @times = 0
      @last_payment = nil
    end

    def cancel_remote_payment_async(payment)
      @times += 1
      @last_payment = payment
    end

    def last_payment
      @last_payment
    end
  end
end