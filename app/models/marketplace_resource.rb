class MarketplaceResource < ActiveResource::Base
  alias read_attribute_for_serialization send

  self.site = MARKETPLACE_API_ENDPOINT
  headers['Authorization'] = "Token token=#{MARKETPLACE_API_TOKEN}"
end
