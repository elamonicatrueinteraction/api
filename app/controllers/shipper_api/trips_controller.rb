module ShipperApi
  class TripsController < BaseController
    include ShipperApi::CurrentAndEnsureDependencyLoader

    def serialize(collection, serializer, adapter = :json, include)
      ActiveModelSerializers::SerializableResource.new(
          collection,
          each_serializer: serializer,
          adapter: adapter,
          include: include
      ).as_json
    end

    def all
      accepted_trips = current_shipper.trips.preload(:orders, :deliveries, :audits)
      pending_trips = Trip.preload(:orders, :deliveries, :audits, :shipper)
                          .joins(:trip_assignments)
                          .where(trip_assignments: {shipper: current_shipper, state: ['assigned', 'broadcasted'], closed_at: nil})
                          .where(status: 'waiting_shipper')
                          .order('trip_assignments.created_at DESC')

      render json: {
          pending: serialize(pending_trips, TripSerializer, [:orders, :deliveries, :audits, :shipper, :trip_assignments, :milestones]),
          accepted: serialize(accepted_trips, TripSerializer, [:orders, :deliveries, :audits, :shipper, :trip_assignments, :milestones])
      }, status: :ok # 200
    end

    def index
      trips = current_shipper.trips.preload(:orders, :deliveries, :packages, :milestones, :trip_assignments)
      render json: trips, status: :ok # 200
    end

    alias_method :accepted, :index

    def pending
      # TO-DO: rethink how we are getting this trips
      trips = Trip.preload(:orders, :deliveries, :packages, :milestones, :trip_assignments)
                  .joins(:trip_assignments)
                  .where(trip_assignments: {shipper: current_shipper, state: ['assigned', 'broadcasted'], closed_at: nil})
                  .where(status: 'waiting_shipper')
                  .order('trip_assignments.created_at DESC')

      render json: trips, status: :ok # 200
    end

    def show
      if trip = current_shipper.trips.find_by(id: params[:id])
        render json: trip, status: :ok # 200
      else
        render json: {errors: I18n.t('errors.not_found.trip', id: params[:id])}, status: :not_found # 404
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
            render json: {errors: service.errors}, status: :unprocessable_entity # 422
          end
        else
          render json: {errors: [I18n.t("errors.not_found.pending_trip", id: params[:id])]}, status: :unprocessable_entity # 422
        end
      else
        render json: {errors: [I18n.t("errors.not_found.trip", id: params[:id])]}, status: :not_found # 404
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
      trip = Trip.find_by(id: params[:trip_id])
      found_institution = false

      if trip
        trip.steps.each do |s|
          if (s["institution"]["id"].eql? params[:institution_id]) && (s["action"].eql? "dropoff")
            delivery = Delivery.find(s["delivery_id"][0])

            if delivery
              found_institution = true
              render json: delivery, serializer: TripInfo::DeliverySerializer, status: :ok # 200
            else
              render json: {errors: [I18n.t('errors.not_found.delivery', id: s["delivery_id"][0])]}, status: :not_found # 404
            end
          end
        end

        unless found_institution
          render json: {errors: [I18n.t('errors.not_found.institution', id: params[:institution_id])]}, status: :not_found # 404
        end

      else
        render json: {errors: [I18n.t('errors.not_found.trip', id: params[:trip_id])]}, status: :not_found # 404
      end
    end

  end
end
