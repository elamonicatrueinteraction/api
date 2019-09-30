module UntrackedActivities
  class CreateUntrackedActivity
    prepend Service::Base

    def initialize(params:)
      @params = params.except(:payment_method)
      @payment_method = params[:payment_method]
    end

    def call
      create
    end

    private

    def create
      activity = UntrackedActivity.new(@params)
      begin
        UntrackedActivity.transaction do
          activity.save!
          create_payment = CreatePayment.call(payable: activity, amount: activity.amount,
                                       payment_type: @payment_method,
                                       payment_comment: activity.reason)
          if create_payment.success?
            payment = create_payment.result
            return {activity: activity, payment: payment}
          end

          errors.add_multiple_errors(create_payment.errors)
        end
      rescue ActiveRecord::RecordInvalid => invalid
          errors.add_multiple_errors(invalid.record.errors)
      end
    end
  end
end