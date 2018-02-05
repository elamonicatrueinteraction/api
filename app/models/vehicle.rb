class Vehicle < ApplicationRecord
  attribute :extras, :jsonb, default: {}

  belongs_to :shipper
  has_many :verifications, as: :verificable, dependent: :destroy

  validates_presence_of :model

  FEATURES = %w(
    air_conditioner
    ABS
    ASR
    AWD
    refrigerated
  ).freeze
  private_constant :FEATURES

  VERIFICATIONS = {
    license_plate: %w(register_date number state city),
    vehicle_title: %w(register_date owner_name state city),
    insurance: %w(register_date type company),
    security_kit: %w(medical fire),
    vtv: %w(required),
    free_traffic_ticket: %w(state)
  }.with_indifferent_access.freeze

  SINGLE_EXTRAS = %w(
    capacity
    gateway_id
  ).freeze
  private_constant :SINGLE_EXTRAS

  def features
    return @features if defined?(@features)

    @features = FEATURES.each_with_object({}) do |feature, _hash|
      _hash[feature] = features_info.include?(feature)
    end
  end

  def features=(value)
    new_values = Array.wrap(value).select{ |v| FEATURES.include?(v) }

    extras['features'] = features_info | new_values

    @features_info = extras['features']
  end

  SINGLE_EXTRAS.each do |extra_name|
    attribute :"#{extra_name}"

    define_method :"#{extra_name}" do
      extras[extra_name]
    end

    define_method :"#{extra_name}=" do |new_value|
      self.extras[extra_name] = new_value
    end
  end

  private

  def features_info
    @features_info ||= Array.wrap(extras['features'])
  end

end
