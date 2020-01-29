# == Schema Information
#
# Table name: trips
#
#  id           :uuid             not null, primary key
#  shipper_id   :uuid
#  status       :string
#  comments     :string
#  amount       :decimal(12, 4)   default(0.0)
#  gateway      :string
#  gateway_id   :string
#  gateway_data :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  steps        :jsonb            not null
#  network_id   :string
#

class TripSerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :status_detail,
    :comments,
    :amount,
    :steps,
    :created_at,
    :updated_at

  belongs_to :shipper, serializer: Simple::ShipperSerializer
  has_many :orders, serializer: Deep::OrderSerializer
  has_many :audits, serializer: AuditSerializer

  # TO-DO: Please rethink this maybe in another place
  def status_detail
    case object.status
    when 'waiting_shipper'
      # object.trip_assignments.where(closed_at: nil).last.try(:state)
      object.status
    when 'confirmed'
      'accepted'
    when 'on_going', 'completed'
      # object.milestones.last.try(:name)
      object.status
    else
      nil
    end
  end
end
