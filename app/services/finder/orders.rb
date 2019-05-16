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
      @orders = Order.preload(:deliveries, :payments).order(created_at: :desc)
      @orders = @orders.where('giver_id = ? OR receiver_id = ?', institution_id, institution_id) if @institution_id

      if @filter_params[:delivery_date]
        date = Time.parse(@filter_params[:delivery_date]).to_date
        @orders = @orders.where("cast(cast(extras -> 'delivery_preference' -> 'day' as text) as date) = ?", date)
      end
      @orders
    end

    attr_reader :institution_id

  end
end
