module Scheduler
  module Jobs
    class RestJob < RestJobBase
      attr_accessor :job
    end
  end
end