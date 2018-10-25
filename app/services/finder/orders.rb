module Finder
  class Orders
    prepend Service::Base
    include Service::Support::Finders

    def initialize(institution: nil, filter_params: {})
      @institution = institution
      @filter_params = filter_params
    end

    def call
      find_orders
    end

    private

    def find_orders
      @orders = Order.preload(:deliveries, :payments, giver: [:addresses], receiver: [:addresses])
      @orders = @orders.where('giver_id = ? OR receiver_id = ?', institution_id, institution_id) if @institution

      @orders
    end

    def institution_id
      @institution.id
    end

  end
end
