class UserApiResource < ActiveResource::Base
  alias read_attribute_for_serialization send

  self.site = "#{USER_SERVICE_ENDPOINT}/resources"
  headers['Authorization'] = "Token token=#{USER_SERVICE_TOKEN}"

  def initialize(args = {}, _arg = nil)
    super(args)
  rescue # rubocop:disable Lint/HandleExceptions, Style/RescueStandardError
  end

  def self.find_by(id: nil)
    find(id)
  rescue ActiveResource::ResourceNotFound, Errno::ECONNREFUSED
    nil
  end

end
