class Deep::OrderSerializer < Simple::OrderSerializer
  attributes :deliveries

  def giver
    institution_data(object.giver).merge( address: pickup_data )
  end

  def receiver
    institution_data(object.receiver).merge( address: dropoff_data )
  end

  def deliveries
    ActiveModelSerializers::SerializableResource.new(
      object.deliveries,
      { each_serializer: Deep::DeliverySerializer }
    ).as_json[:deliveries]
  end

  private

  def pickup_data
    pickup_hash = delivery.pickup

    {
      latlng: delivery.origin_latlng,
      lookup: lookup_address(pickup_hash[:address])
    }
  end

  def dropoff_data
    dropoff_hash = delivery.dropoff

    {
      latlng: delivery.destination_latlng,
      lookup: lookup_address(dropoff_hash[:address])
    }
  end

  def delivery
    @delivery ||= object.deliveries.first
  end

  def lookup_address(address_hash)
    [
      address_hash[:street_1],
      address_hash[:street_2],
      [address_hash[:zip_code], address_hash[:city]].compact.join(' '),
      address_hash[:state],
      address_hash[:country]
    ].select{ |string| string.present? }.join(', ')
  end
end
