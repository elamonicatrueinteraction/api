module Scheduler
  module Provider
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def self.logistic_scheduler
      configuration.logistic_scheduler
    end

    class Configuration
      attr_accessor :logistic_scheduler
    end
  end
end