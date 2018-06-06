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
    @milestone = @trip.milestones.new( milestone_params(@allowed_params) )

    return if errors.any?

    if @milestone.save
      UpdateTripStatus.call(@milestone)

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
