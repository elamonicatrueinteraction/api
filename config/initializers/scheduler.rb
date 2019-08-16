
scheduler_url = Rails.application.secrets.scheduler_url
scheduler_token = Rails.application.secrets.scheduler_token
job_endpoint = Rails.application.secrets.job_endpoint
job_token = Rails.application.secrets.job_token

logistic_scheduler = Scheduler::GreenScheduler.new(api_endpoint: job_endpoint, job_token: job_token,
                                                   scheduler_end_point: scheduler_url, scheduler_token: scheduler_token)

Scheduler::Provider.configure do |config|
  config.logistic_scheduler = logistic_scheduler
end