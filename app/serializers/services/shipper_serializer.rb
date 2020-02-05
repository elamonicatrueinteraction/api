module Services
  class ShipperSerializer < ActiveModel::Serializer
    attributes :id, :tokens, :name

    def tokens
      android_tokens = object.devices.nil? ? nil : object.devices["android"]
      return [] if android_tokens.nil?

      android_tokens.keys
    end
  end
end