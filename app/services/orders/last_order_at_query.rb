module Orders
  class LastOrderAtQuery

    def initialize(network_id:)
      @network_id = network_id
      @base_collection = Order.all
    end

    def query(institution_id: nil)
      orders = @base_collection
      orders = orders.where(network_id: @network_id) if @network_id
      orders = orders.where(receiver_id: institution_id) unless institution_id.nil?
      orders.group(:receiver_id).maximum(:created_at)
    end
  end
end