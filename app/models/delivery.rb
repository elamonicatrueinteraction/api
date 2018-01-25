class Delivery < ApplicationRecord
  attribute :amount, :float
  attribute :bonified_amount, :float
  attribute :origin_latlng
  attribute :destination_latlng
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
end
