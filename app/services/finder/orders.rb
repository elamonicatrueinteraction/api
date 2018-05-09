module Finder
  class Orders
    prepend Service::Base

    def initialize(institution)
      @institution = institution
    end

    def call
      find_orders
    end

    private

    def find_orders
      @orders = Order.preload(:giver, :receiver, :deliveries, :packages)
      @orders = @orders.where('giver_id = ? OR receiver_id = ?', institution_id, institution_id) if @institution

      @orders
    end

    def institution_id
      @institution.id
    end

  end
end
