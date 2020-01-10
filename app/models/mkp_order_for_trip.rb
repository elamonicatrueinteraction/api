class MkpOrderForTrip < ActiveResource::Base
  self.site = 'http://localhost:9090/services/trip'
  headers['Authorization'] = "Token token=#{Rails.application.secrets.marketplace_token}"

  #self.element_name = 'orders'
  self.collection_name = 'orders'
  self.timeout = 5
end
