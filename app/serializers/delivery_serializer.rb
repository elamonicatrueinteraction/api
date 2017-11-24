class DeliverySerializer < ActiveModel::Serializer
  attributes :id,
    :amount,
    :bonified_amount,
    :status,
    :created_at,
    :updated_at,
    :packages

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  belongs_to :order

  def packages
    object.packages.map do |package|
      package.attributes.slice('id','weigth','volume','cooling','description')
    end
  end
end



