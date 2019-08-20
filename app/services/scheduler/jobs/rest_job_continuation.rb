module Scheduler
  module Jobs
    class RestJobContinuation
      attr_accessor :jobs
      attr_accessor :StopOnFailure

      def initialize
        @jobs = []
        @StopOnFailure = false
      end
    end
  end
end
