module ShipperApi
  class TripsController < BaseController
    include ShipperApi::CurrentAndEnsureDependencyLoader

    def index
      trips = current_shipper.trips.preload(:orders, :deliveries)
      render json: trips, status: :ok # 200
    end
    alias_method :accepted, :index

    def pending
      # TO-DO: rethink how we are getting this trips
      trips = Trip.preload(:orders, :deliveries, :packages, :milestones, :trip_assignments)
        .joins(:trip_assignments)
        .where(trip_assignments: { shipper: current_shipper, state: ['assigned', 'broadcasted'], closed_at: nil })
        .where(status: 'waiting_shipper')
        .order('trip_assignments.created_at DESC')

      render json: trips, status: :ok # 200
    end

    def show
      if trip = current_shipper.trips.find_by(id: params[:id])
        render json: trip, status: :ok # 200
      else
        render json: { errors: I18n.t('errors.not_found.trip', id: params[:id]) }, status: :not_found # 404
      end
    end

    def accept
      # TO-DO: We should improve this handling
      if pending_trip = Trip.find_by(id: params[:id])
        if [nil, 'waiting_shipper'].include?(pending_trip.status)
          service = ShipperApi::AcceptTrip.call(current_shipper, pending_trip)

          if service.success?
            render json: service.result, status: :ok # 200
          else
            render json: { errors: service.errors }, status: :unprocessable_entity # 422
          end
        else
          render json: { errors: [ I18n.t("errors.not_found.pending_trip", id: params[:id]) ] }, status: :unprocessable_entity # 422
        end
      else
        render json: { errors: [ I18n.t("errors.not_found.trip", id: params[:id]) ] }, status: :not_found # 404
      end
    end

    # def reject
    #   ensure_trip; return if performed?

    #   service = ShipperApi::RejectTrip.call(current_shipper, current_trip)

    #   if service.success?
    #     render json: service.result, status: :created # 201
    #   else
    #     render json: { errors: service.errors }, status: :unprocessable_entity # 422
    #   end
    # end

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
