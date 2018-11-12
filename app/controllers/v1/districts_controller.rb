module V1
  class DistrictsController < ApplicationController
    def index
      render json: DistrictQuery.new(params).collection
    end
  end
end
