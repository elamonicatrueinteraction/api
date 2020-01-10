module TripInfo
  class DeliverySerializer < ActiveModel::Serializer
    attributes :institution_name, :packages

    def institution_name
      object.dropoff['place']
    end

    def packages
      #remote_order_ids = object.map { |delivery| delivery&.order.marketplace_order_id }
      remote_order_id = object.order.marketplace_order_id
      if remote_order_id.nil?
        TripInfo::NestedDeliverySerializer.new(object).as_json
      else
        MkpOrderForTrip.find(remote_order_id).as_json
      end
    end

  end
end
