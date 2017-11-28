class OrderSerializer < ActiveModel::Serializer
  attributes :id,
    :expiration,
    :amount,
    :bonified_amount,
    :created_at,
    :updated_at

  belongs_to :giver, class_name: 'Institution'
  belongs_to :receiver, class_name: 'Institution'

  has_many :deliveries
end
