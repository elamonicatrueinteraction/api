class DeliverySerializer < Simple::DeliverySerializer
  attributes :packages,
    :created_at,
    :updated_at

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  belongs_to :order

  def packages
    object.packages.map do |package|
      package.attributes.slice('id','weigth','volume','cooling','description')
    end
  end
end


