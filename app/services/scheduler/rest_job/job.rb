module Scheduler
  module RestJob
    class Job
      attr_accessor :id
      attr_accessor :type
      attr_accessor :retry_on_failure
      attr_accessor :verb
      attr_accessor :url
      attr_accessor :body


      def initialize(type, retry_on_failure, verb, url, body)
        @type = type
        @retry_on_failure = retry_on_failure
        @verb = verb
        @url = url
        @body = body.try(:to_json)
      end
    end
  end
end