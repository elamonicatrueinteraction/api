class Vehicle < ApplicationRecord
  attribute :extras, :jsonb, default: {}

  belongs_to :shipper
  has_many :verifications, as: :verificable

  validates_presence_of :model

  FEATURES = %w(
    air_conditioner
    ABS
    ASR
    AWD
  ).freeze

  VERIFICATIONS = {
    license_plate: %w(register_date number state city),
    vehicle_title: %w(register_date owner_name state city),
    insurance: %w(register_date type company),
    security_kit: %w(medical fire),
    vtv: %w(required),
    free_traffic_ticket: %w(state)
  }.with_indifferent_access.freeze

  def features
    return @features if @features

    @features = FEATURES.each_with_object({}) do |feature, _hash|
      _hash[feature] = (extras['features'] || []).include?(feature)
    end
  end

end
