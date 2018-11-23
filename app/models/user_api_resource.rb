class UserApiResource < ActiveResource::Base
  alias read_attribute_for_serialization send

  self.site = "#{USER_SERVICE_ENDPOINT}/resources"
  headers['Authorization'] = "Token token=#{USER_SERVICE_TOKEN}"

  class << self
    attr_accessor :current_network
  end

  def initialize(args = {}, _arg = nil)
    super(args)
  rescue # rubocop:disable Lint/HandleExceptions, Style/RescueStandardError
  end

  def self.find_by(id: nil)
    Rails.logger.info "Find User resource with #{headers['X-Network-ID']}"
    Rails.logger.info(
      "Find User resource with #{UserApiResource.current_network}"
    )
    ActiveResource::Base.headers['X-Network-Id'] =
      UserApiResource.current_network
    find(id)
  rescue ActiveResource::ResourceNotFound, Errno::ECONNREFUSED
    nil
  end

  def self.default_scope_by_network(current_network)
    return unless current_network

    Rails.logger.info "User resource with current network #{current_network}"
    Rails.logger.info "User resource with network #{headers['X-Network-ID']}"
    UserApiResource.current_network = current_network
    headers['X-Network-ID'] = current_network
  end
end
