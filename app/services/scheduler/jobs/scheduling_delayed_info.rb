module Scheduler
  module Jobs
    class SchedulingDelayedInfo
      attr_accessor :days
      attr_accessor :hours
      attr_accessor :minutes
      attr_accessor :seconds

      def initialize(days, hours, minutes, seconds)
        @days = days
        @hours = hours
        @minutes = minutes
        @seconds = seconds
      end
    end
  end
end