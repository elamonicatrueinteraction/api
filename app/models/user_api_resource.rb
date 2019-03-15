class UserApiResource < ActiveResource::Base
  alias read_attribute_for_serialization send

  self.site = Rails.application.secrets.user_endpoint
  headers['Authorization'] = "Token token=#{Rails.application.secrets.user_token}"

  class << self
    attr_accessor :current_network
  end

  def initialize(args = {}, _arg = nil)
    super(args)
  rescue # rubocop:disable Lint/HandleExceptions, Style/RescueStandardError
  end

  def self.find_by(id: nil)
    find(id)
  rescue ActiveResource::ResourceNotFound, Errno::ECONNREFUSED
    nil
  end

  def self.default_scope_by_network(current_network)
    return unless current_network

    UserApiResource.current_network = current_network
    headers['X-Network-ID'] = current_network
  end
end
