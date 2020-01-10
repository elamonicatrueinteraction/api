module TripInfo
  class PackageSerializer < ActiveModel::Serializer
    attributes :id, :title, :subtitle, :total

    def title
      object.description
    end

    def subtitle
      "-"
    end

    def total
      "#{object.weight} Kg"
    end
  end
end
