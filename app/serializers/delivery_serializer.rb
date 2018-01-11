class DeliverySerializer < Simple::DeliverySerializer
  attributes :packages,
    :created_at,
    :updated_at

  belongs_to :origin, class_name: 'Address'
  belongs_to :destination, class_name: 'Address'

  belongs_to :order

  def packages
    object.packages.map do |package|
      package.attributes.slice('id','quantity','weigth','volume','cooling','fragile','description')
    end
  end
end



