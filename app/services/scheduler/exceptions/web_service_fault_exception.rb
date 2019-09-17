module Scheduler
  module Exceptions
    class WebServiceFaultException < Exception
      attr_accessor :inner_exception
    end
  end
end