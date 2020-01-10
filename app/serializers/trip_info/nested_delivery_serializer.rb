module TripInfo
  class NestedDeliverySerializer < ActiveModel::Serializer
    attributes :total_products, :total_bulks, :total_weight, :items

    def total_products
      object.packages.count

    end

    def total_weight
      "#{object.packages.map(&:weight).sum} Kg"
    end

    def total_bulks
      "NA"
    end

    def items
      ActiveModelSerializers::SerializableResource.new(
          object.packages,
          {each_serializer: TripInfo::PackageSerializer}
      ).as_json[:packages]
    end
  end
end
