class UserApiResource < ActiveResource::Base
  alias :read_attribute_for_serialization :send

  self.site = "#{USER_SERVICE_ENDPOINT}/resources"
  self.headers['Authorization'] = "Token token=#{USER_SERVICE_TOKEN}"

  def self.find_by(id: nil)
    begin
      find(id)
    rescue ActiveResource::ResourceNotFound, Errno::ECONNREFUSED => e
      nil
    end
  end

end
