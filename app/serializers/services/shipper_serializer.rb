module Services
  class ShipperSerializer < ActiveModel::Serializer
    attributes :id, :token, :name

    def token
      android_tokens = object.devices.nil? ? nil : object.devices["android"]
      return "" if android_tokens.nil?

      android_tokens.keys[0]
    end
  end
end