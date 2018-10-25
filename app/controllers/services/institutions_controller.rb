module Services
  class InstitutionsController < BaseController

    def show
      if institution = Institution.find_by(id: params[:id])
        render json: institution, status: :ok # 200
      else
        render json: nil, status: :not_found # 404
      end
    end

    def index
      institutions = Institution.all.includes(:addresses, :users)
      institutions = institutions.where(filtered_params) if filtered_params.present?

      render json: institutions, status: :ok # 200
    end

    private

    def filtered_params
      @filtered_params ||= params.to_unsafe_hash.keep_if do |key, value|
        institution_attributes.include?(key.to_s)
      end
    end

    def institution_attributes
      @institution_attributes ||= Institution.new.attributes.keys
    end

  end
end
