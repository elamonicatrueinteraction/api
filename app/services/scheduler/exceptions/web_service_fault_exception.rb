module Scheduler
  class WebServiceFaultException < Exception
    attr_accessor :inner_exception
  end
end