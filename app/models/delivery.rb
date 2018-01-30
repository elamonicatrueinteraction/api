class Delivery < ApplicationRecord
  attribute :amount, :float
  attribute :bonified_amount, :float
  attribute :origin_latlng
  attribute :destination_latlng
  attribute :extras, :jsonb, default: {}
  attribute :pickup, :jsonb, default: {}
  attribute :dropoff, :jsonb, default: {}

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'
  belongs_to :order
  belongs_to :trip, optional: true
  has_one :giver, through: :order, class_name: 'Institution'
  has_one :receiver, through: :order, class_name: 'Institution'
  has_many :packages, dependent: :destroy

  VALID_STATUS = %w(
    draft
    scheduled
    processing
    broadcasting
    assigned
    confirmed_to_pickup
    at_pickup
    on_delivery
    at_dropoff
    completed
    canceled
    returning
    returned
    hold_by_courier
  ).freeze
  private_constant :VALID_STATUS

  OPTIONS = %w(
    refrigerated
  ).freeze
  private_constant :OPTIONS

  def options
    return @options if defined?(@options)

    @options = OPTIONS.each_with_object({}) do |feature, _hash|
      _hash[feature] = options_info.include?(feature)
    end
  end

  def options=(value)
    new_values = Array.wrap(value).select{ |v| OPTIONS.include?(v) }

    extras['options'] = options_info | new_values

    @options_info = extras['options']
  end

  def self.valid_status
    VALID_STATUS
  end

  def self.default_status
    'processing'
  end

  def origin_latlng
    return unless origin_gps_coordinates

    origin_gps_coordinates.coordinates.reverse.join(", ")
  end

  def destination_latlng
    return unless destination_gps_coordinates

    destination_gps_coordinates.coordinates.reverse.join(", ")
  end

  private

  def options_info
    @options_info ||= Array.wrap(extras['options'])
  end


end
