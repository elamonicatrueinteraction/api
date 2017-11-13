# Internal: Ability to handle the loading of the vehicle when required
module VehicleLoader
  extend ActiveSupport::Concern

  private

  def current_vehicle
    return @current_vehicle if defined?(@current_vehicle)

    return unless vehicle_id = params[:vehicle_id]

    @current_vehicle = Vehicle.find_by(id: vehicle_id)
  end

  def ensure_vehicle
    unless current_vehicle
      if vehicle_id = params[:vehicle_id]
        render json: { error: I18n.t('not_found.vehicle', vehicle_id: vehicle_id) }, status: :not_found and return
      else
        render json: { error: I18n.t('missing.vehicle') }, status: :bad_request and return
      end
    end
  end
end
