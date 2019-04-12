# == Schema Information
#
# Table name: milestones
#
#  id              :bigint(8)        not null, primary key
#  trip_id         :uuid
#  name            :string
#  comments        :text
#  data            :jsonb
#  gps_coordinates :geography({:srid point, 4326
#  created_at      :datetime
#  network_id      :string
#

class Milestone < ApplicationRecord
  default_scope_by_network
  attribute :data, :jsonb, default: {}

  belongs_to :trip
  has_one :shipper, through: :trip

  validates_presence_of :name, :gps_coordinates

  attribute :latlng
  def latlng
    return unless gps_coordinates

    gps_coordinates.coordinates.reverse.join(",")
  end
end
