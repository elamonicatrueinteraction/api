class InstitutionsController < ApplicationController

  def index
    institutions = Institution.preload(:addresses).all
    render json: institutions, status: :ok # 200
  end

  def show
    institution = Institution.find_by(id: params[:id])
    render json: institution, status: :ok # 200
  end

  def create
    load_and_ensure_institution_type; return if performed?

    institution = @type_class.create(institution_params)
    # TODO: Create a service to handle all this
    if institution.valid?
      render json: institution, status: :created # 201
    else
      render json: { error: institution.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  def update
    if institution = Institution.find_by(id: params[:id])
      institution.update(institution_params)
      # TODO: Create a service to handle all this
      if institution.valid?
        render json: institution, status: :ok # 200
      else
        render json: { error: institution.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.institution', id: params[:id]) }, status: :not_found # 404
    end
  end

  def destroy
    if institution = Institution.find_by(id: params[:id])
      if institution.destroy
        render json: { institution: institution.id }, status: :ok # 200
      else
        render json: { error: institution.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.institution', id: params[:id]) }, status: :not_found # 404
    end
  end

  private

  def institution_params
    params.permit(
      :name,
      :legal_name,
      :uid_type,
      :uid
    )
  end

  def load_and_ensure_institution_type
    type = params[:type].try(:downcase)

    if type && Institution.valid_types.include?(type)
      @type_class = "Institutions::#{type.classify}".constantize
    else
      render json: { error: I18n.t("errors.params.institution.type", allowed_types: Institution.valid_types.join(', ')) }, status: :bad_request and return
    end
  end

end
