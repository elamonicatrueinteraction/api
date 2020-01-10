module V2
  class TripsController < ApplicationController
    def drop_off_info
      trip = Trip.includes(deliveries: [:packages]).find_by(id: params[:id])
      if trip
        render json: trip, serializer: TripInfo::TripSerializer, status: :ok # 200
      else
        render json: {errors: [I18n.t('errors.not_found.trip', id: params[:id])]}, status: :not_found # 404
      end
    end
  end
end
