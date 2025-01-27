# Internal: Ability to handle the loading of the required object if needed
module CurrentAndEnsureDependencyLoader
  extend ActiveSupport::Concern

  private

  MODELS_TO_LOAD = %w(
    delivery
    institution
    order
    shipper
    vehicle
  ).freeze
  private_constant :MODELS_TO_LOAD

  MODELS_TO_LOAD.each do |model_name|
    define_method :"current_#{model_name}" do
      return instance_variable_get("@current_#{model_name}") if instance_variable_defined?("@current_#{model_name}")

      return unless id = params[:"#{model_name}_id"]

      class_name = model_name.classify.constantize

      instance_variable_set("@current_#{model_name}", class_name.find_by(id: id))
    end

    define_method :"ensure_#{model_name}" do
      unless send(:"current_#{model_name}")
        if id = params[:"#{model_name}_id"]
          render json: { errors: [ I18n.t("errors.not_found.#{model_name}", id: id) ] }, status: :not_found and return
        else
          render json: { errors: [ I18n.t("errors.missing.#{model_name}") ] }, status: :bad_request and return
        end
      end
    end

    define_method :"optional_#{model_name}" do
      return unless params[:"#{model_name}_id"]

      return if send(:"current_#{model_name}")

      render json: { errors: [ I18n.t("errors.not_found.#{model_name}", id: params[:"#{model_name}_id"]) ] }, status: :not_found and return
    end
  end
end
