# Internal: Ability to handle the loading of the shipper when required
module ShipperLoader
  extend ActiveSupport::Concern

  private

  def current_shipper
    return @current_shipper if defined?(@current_shipper)

    return unless shipper_id = params[:shipper_id]

    @current_shipper = Shipper.find_by(id: shipper_id)
  end

  def ensure_shipper
    unless current_shipper
      if shipper_id = params[:shipper_id]
        render json: { error: I18n.t('not_found.shipper', shipper_id: shipper_id) }, status: :not_found and return
      else
        render json: { error: I18n.t('missing.shipper') }, status: :bad_request and return
      end
    end
  end
end
