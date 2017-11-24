class Delivery < ApplicationRecord
  belongs_to :order
  has_many :packages, dependent: :destroy

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  # TO-DO: We should remove this when we add the Trip model relationship
  def trip
    trip_id
  end
end
