class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    attr_accessor :current_network
  end

  def self.default_scope_by_network
    default_scope do
      next all unless ApplicationRecord.current_network

      where(network_id: ApplicationRecord.current_network)
    end
  end
end
