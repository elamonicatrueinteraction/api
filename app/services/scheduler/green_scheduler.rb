module Scheduler
  class GreenScheduler

    def initialize(api_endpoint:, job_token:, scheduler_end_point:, scheduler_token:)
      @client = GreenSchedulerClient.new(end_point: scheduler_end_point, token: scheduler_token)
      @api_endpoint = api_endpoint
      @job_token = job_token
    end

    def ping_async
      payload = build_job_info(url: "_healthcheck",
                               verb: 'GET', retry_on_failure: false)
      @client.fire_and_forget(payload)
    end

    def cancel_remote_payment_async(payment)
      payload = build_job_info(url: "job/cancel_remote_payment/#{payment.id}",
                               verb: 'GET', retry_on_failure: false)
      @client.fire_and_forget(payload)
    end

    private

    def build_job_info(url:, verb: 'GET', retry_on_failure: false, body: {})
      return { retry_on_failure: retry_on_failure, verb: verb, url: build_url(url) } if verb == 'GET'

      { retry_on_failure: retry_on_failure, verb: verb, url: build_url(url), body: body }
    end

    def build_url(method)
      "#{@api_endpoint}#{method}?token=#{@job_token}"
    end
  end
end
