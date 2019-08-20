module Services
  class OrderQuery
    include Querifier::Queries::Default

    where_attributes :id, :institution_id
    order_attributes :id

    def filter_by_institution_id(institution_id)
      @collection = @collection.where('giver_id = :id OR receiver_id = :id', id: institution_id)
                              .includes(:payments, deliveries: [:payments])
    end

    def filter_params
      @filter_params ||= @params.select { |k| valid_option? k.to_sym }
    end
  end
end
