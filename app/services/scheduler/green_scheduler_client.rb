module Scheduler
  class GreenSchedulerClient
    attr_accessor :jobs
    attr_accessor :continuations
    attr_reader :end_point

    def initialize(end_point:, token:)
      @end_point = end_point
      @token = token
      throw Exceptions::WebServiceFaultException.new('Debe configurar el end point y el token del scheduler') if @end_point.blank? || @token.blank?
      reset_collections
    end

    def reset_collections
      @jobs = []
      @continuations = []
    end

    def commit_batch
      batch_request = BatchRequest.new(@jobs, @continuations)
      response = GreenRestClient.call(get_url_for('JobsBatchUpdate'), 'POST', batch_request, nil)
      reset_collections
      response
    end

    def fire_and_forget(job_info)
      rest_job = build_fire_and_forget(job_info)
      GreenRestClient.call(get_url_for('Create'), 'POST', rest_job, nil)['id']
    end

    def fire_and_forget_add_to_batch(job_info)
      @jobs << build_fire_and_forget(job_info)
    end

    def build_fire_and_forget(job_info)
      rest_job = Scheduler::Jobs::RestJob.new
      rest_job.job = Scheduler::Jobs::Job.new('fire-and-forget', job_info[:retry_on_failure], job_info[:verb], job_info[:url], job_info[:body])

      rest_job
    end

    def delayed(job_info, days, hours, minutes, seconds)
      rest_job = build_delayed(job_info, days, hours, minutes, seconds)
      GreenRestClient.call(get_url_for('Create'), 'POST', rest_job, nil)['id']
    end

    def delayed_add_to_batch(job_info, days, hours, minutes, seconds)
      @jobs << build_delayed(job_info, days, hours, minutes, seconds)
    end

    def build_delayed(job_info, days, hours, minutes, seconds)
      rest_job = Scheduler::Jobs::RestJob.new
      rest_job.job = Scheduler::Jobs::Job.new('delayed', job_info[:retry_on_failure], job_info[:verb], job_info[:url], job_info[:body])
      rest_job.SchedulingInfo = Scheduler::Jobs::SchedulingInfo.new
      rest_job.SchedulingInfo.delayed = Scheduler::Jobs::SchedulingDelayedInfo.new(days, hours, minutes, seconds)
      rest_job
    end

    def recurring(id, job_info, cron_expression)
      rest_job = build_recurring(id, job_info, cron_expression)
      GreenRestClient.call(get_url_for('Create'), 'POST', rest_job, nil)['id']
    end

    def recurring_add_to_batch(id, job_info, cron_expression)
      @jobs << build_recurring(id, job_info, cron_expression)
    end

    def build_recurring(id, job_info, cron_expression)
      rest_job = Scheduler::Jobs::RestJob.new
      rest_job.job = Scheduler::Jobs::Job.new('recurring', job_info[:retry_on_failure], job_info[:verb], job_info[:url], job_info[:body])
      rest_job.job.id = id
      rest_job.SchedulingInfo = Scheduler::Jobs::SchedulingInfo.new
      rest_job.SchedulingInfo.CronExpression = cron_expression

      rest_job
    end

    def continuation(jobs, stop_on_failure = true)
      rest_job_continuation = build_continuation(jobs, stop_on_failure)
      GreenRestClient.call(get_url_for('CreateContinuation'), 'POST', rest_job_continuation, nil)['id']
    end

    def continuation_add_to_batch(jobs, stop_on_failure = true)
      @continuations << build_continuation(jobs, stop_on_failure)
    end

    def build_continuation(jobs, stop_on_failure = true)
      rest_job_continuation = Scheduler::Jobs::RestJobContinuation.new
      rest_job_continuation.jobs = jobs.map do |job_info|
        Scheduler::Jobs::Job.new('fire-and-forget', job_info[:retry_on_failure], job_info[:verb], job_info[:url], job_info[:body])
      end
      rest_job_continuation.StopOnFailure = stop_on_failure

      rest_job_continuation
    end

    private

    def get_url_for(action)
      @end_point + "api/RestJobs/#{action}?auth_token=#{@token}"
    end
  end

  class BatchRequest
    attr_accessor :jobs
    attr_accessor :continuations

    def initialize(jobs, continuations)
      @jobs = jobs
      @continuations = continuations
    end
  end
end
