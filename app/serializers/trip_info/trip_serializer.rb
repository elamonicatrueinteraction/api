module TripInfo
  class TripSerializer < ActiveModel::Serializer
    attributes :id, :drop_off_info

    def drop_off_info
      ActiveModelSerializers::SerializableResource.new(
          object.deliveries,
          {each_serializer: TripInfo::DeliverySerializer}
      ).as_json[:deliveries]
    end
  end
end
