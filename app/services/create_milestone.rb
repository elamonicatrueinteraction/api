class CreateMilestone
  prepend Service::Base

  def initialize(trip, allowed_params)
    @trip = trip
    @allowed_params = allowed_params
  end

  def call
    create_milestone
  end

  private

  def create_milestone
    @milestone = @trip.milestones.new(milestone_params(@allowed_params))

    return if errors.any?

    if @milestone.save
      UpdateTripStatus.call(@milestone)

      #  Notify the institution
      if @allowed_params[:name].match(/heading_to_dropoff/i)
        delivery_dropoff_number = @allowed_params[:name][-1]

        institution_name = @trip.deliveires[delivery_dropoff_number]["dropoff"]["place"]
        institution = Institution.where(:name => institution_name).first

        users_ids = institution.users.map(&:id)
        tokens_ids = MobileToken.where(user_id: users_ids).map(&:firebase_token)

        institution_notifier = Notifications::InstitutionNotifier.new(tokens_ids)
        institution_notifier.notify({title: "Tu pedido está en camino", body: "El flete llegara al domicilio de entrega en la brevedad"})
      end

      return @milestone
    end

    errors.add_multiple_errors(@milestone.errors.messages) && nil
  end

  def milestone_params(allowed_params)
    allowed_params.tap do |_params|
      if _params[:latlng]
        _params[:gps_coordinates] = valid_coordinate_point(_params[:latlng])
      else
        errors.add(:type, I18n.t("services.milestone.latlng.missing"))
      end
    end
  end

  def valid_coordinate_point(data)
    lat, lng = data.split(',')
    "POINT (#{lng} #{lat})"
  end

end
