class MkpOrderForTrip < ActiveResource::Base
  self.site = "#{Rails.application.secrets.marketplace_endpoint}/trip"

  headers['Authorization'] = "Token token=#{Rails.application.secrets.marketplace_token}"

  #self.element_name = 'orders'
  self.collection_name = 'orders'
  self.timeout = 5
end
