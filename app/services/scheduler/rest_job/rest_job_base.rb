module Scheduler
  module RestJob
    class RestJobBase
      attr_accessor :SchedulingInfo

      def initialize
        @SchedulingInfo = GreenSchedulerClient::RestJob::SchedulingInfo.new
      end
    end
  end
end