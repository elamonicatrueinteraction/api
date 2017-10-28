class HomeController < ApplicationController

  def show
    render json: { data: "Hi! ready when you are" }, status: :ok
  end

end
