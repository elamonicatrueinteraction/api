class HomeController < ApplicationController

  def show
    render json: { message: "Hi!" }, status: :ok
  end

end
