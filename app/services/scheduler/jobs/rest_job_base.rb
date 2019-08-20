module Scheduler
  module Jobs
    class RestJobBase
      attr_accessor :SchedulingInfo

      def initialize
        @SchedulingInfo = Jobs::SchedulingInfo.new
      end
    end
  end
end