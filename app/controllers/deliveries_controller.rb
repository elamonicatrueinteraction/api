class DeliveriesController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_order; return if performed?

    deliveries = current_order.deliveries
    render json: deliveries, status: :ok # 200
  end

end
