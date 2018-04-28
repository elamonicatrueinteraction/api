module ShipperApi
  class MilestonesController < BaseController
    include ShipperApi::CurrentAndEnsureDependencyLoader

    def create
      ensure_trip; return if performed?

      service = CreateMilestone.call(current_trip, milestone_params)

      if service.success?
        render json: service.result, status: :created # 201
      else
        render json: { errors: service.errors }, status: :unprocessable_entity # 422
      end
    end

    private

    def milestone_params
      params.permit(
        :name,
        :latlng,
        :comments,
        data: {}
      )
    end

  end
end
