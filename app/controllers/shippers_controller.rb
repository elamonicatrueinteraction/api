class ShippersController < ApplicationController
  def show
    @shippers = Shipper.all.as_json
    render json: { data: @shippers }, status: :ok
  end

  def create
    @shipper = Shipper.new(params[:shipper])
    if @shipper.save
      render json: { data: @shipper }, status: :ok
    else
      render json: {error: @shipper.errors.full_messages}, status: 422
    end
  end
end
