module Finder
  class Orders
    prepend Service::Base
    include Service::Support::Finders

    def initialize(institution_id: nil, filter_params: {})
      @institution_id = institution_id
      @filter_params = filter_params
    end

    def call
      find_orders
    end

    private

    def find_orders
      @orders = Order.preload(:deliveries, :payments).order(created_at: :desc).limit(30)
      @orders = @orders.where('giver_id = ? OR receiver_id = ?', institution_id, institution_id) if @institution_id

      @orders
    end

    attr_reader :institution_id

  end
end
