# == Schema Information
#
# Table name: deliveries
#
#  id                          :bigint(8)        not null, primary key
#  order_id                    :uuid
#  trip_id                     :uuid
#  amount                      :decimal(12, 4)   default(0.0)
#  bonified_amount             :decimal(12, 4)   default(0.0)
#  origin_id                   :uuid
#  origin_gps_coordinates      :geography({:srid point, 4326
#  destination_id              :uuid
#  destination_gps_coordinates :geography({:srid point, 4326
#  status                      :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  gateway                     :string
#  gateway_id                  :string
#  gateway_data                :jsonb
#  pickup                      :jsonb
#  dropoff                     :jsonb
#  extras                      :jsonb
#

class Delivery < ApplicationRecord
  attribute :amount, :float
  attribute :bonified_amount, :float
  attribute :origin_latlng
  attribute :destination_latlng
  attribute :extras, :jsonb, default: {}
  attribute :pickup, :jsonb, default: {}
  attribute :dropoff, :jsonb, default: {}

  include Payable

  # belongs_to :origin, class_name: 'Address'
  # belongs_to :destination, class_name: 'Address'
  belongs_to :order
  belongs_to :trip, optional: true
  # has_one :giver, through: :order, class_name: 'Institution'
  # has_one :receiver, through: :order, class_name: 'Institution'
  has_many :packages, dependent: :destroy

  VALID_STATUS = %w(
    processing
    assigned
    on_route
    completed
    canceled
  ).freeze
  private_constant :VALID_STATUS

  OPTIONS = %w(
    refrigerated
  ).freeze
  private_constant :OPTIONS

  validates :origin, :destination, presence: true

  def origin
    return nil if origin_id.nil?

    @origin ||= Services::Address.find(origin_id)
  end
  attribute :origin

  def destination
    return nil if destination_id.nil?

    @destination ||= Services::Address.find(destination_id)
  end
  attribute :destination

  def origin_gps_coordinates
    return if origin.nil?

    RGeo::Geographic::SphericalPointImpl.new(
      RGeo::Geographic.spherical_factory(srid: 4326),
      origin.gps_coordinates.coordinates.first,
      origin.gps_coordinates.coordinates.last
    )
  end

  def destination_gps_coordinates
    return if destination.nil?

    RGeo::Geographic::SphericalPointImpl.new(
      RGeo::Geographic.spherical_factory(srid: 4326),
      destination.gps_coordinates.coordinates.first,
      destination.gps_coordinates.coordinates.last
    )
  end

  def giver
    @giver ||= order.giver
  end

  def receiver
    @receiver ||= order.receiver
  end

  def options
    return @options if defined?(@options)

    @options = OPTIONS.each_with_object({}) do |feature, _hash|
      _hash[feature] = options_info.include?(feature)
    end
  end

  def options=(value)
    new_values = Array.wrap(value).select{ |v| OPTIONS.include?(v) }

    @options_info = extras['options'] = new_values
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

  def total_amount
    (amount.to_f - bonified_amount.to_f).to_f
  end

  def is_paid?
    (approved_payments.sum(&:amount).to_f - total_amount) >=0
  end

  private

  def options_info
    @options_info ||= Array.wrap(extras['options'])
  end

  def approved_payments
    payments.select(&:approved?)
  end

  def network_id
    order.network_id
  end

end
