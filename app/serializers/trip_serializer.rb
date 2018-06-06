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

  # TO-DO: Please rethink this maybe in another place
  def status_detail
    case object.status
    when 'waiting_shipper'
      object.trip_assignments.where(closed_at: nil).last.try(:state)
    when 'confirmed'
      'accepted'
    when 'on_going', 'completed'
      object.milestones.last.try(:name)
    else
      nil
    end
  end
end
