module Scheduler
  module Provider
    class << self
      attr_accessor :configuration
    end

    def self.configure
      yield(configuration)
    end

    def self.configuration
      @@configuration ||= Configuration.new
    end

    def self.logistic_scheduler
      configuration.logistic_scheduler
    end

    class Configuration
      attr_accessor :logistic_scheduler
    end
  end
end