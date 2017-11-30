class PackagesController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_delivery; return if performed?

    packages = current_delivery.packages
    render json: packages, status: :ok # 200
  end

  def show
    ensure_delivery; return if performed?

    if package = current_delivery.packages.find_by(id: params[:id])
      render json: package, status: :ok # 200
    else
      render json: { error: I18n.t('errors.not_found.package', package_id: params[:id], delivery_id: params[:delivery_id]) }, status: :not_found # 404
    end
  end

  def create
    ensure_delivery; return if performed?

    service = CreatePackages.call(current_delivery, create_packages_params[:packages])

    if service.success?
      render json: service.result, status: :created # 201
    else
      render json: { error: service.errors }, status: :unprocessable_entity # 422
    end
  end

  def update
    ensure_delivery; return if performed?

    if package = current_delivery.packages.find_by(id: params[:id])
      service = UpdatePackage.call(package, update_package_params)

      if service.success?
        render json: service.result, status: :created # 201
      else
        render json: { error: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.package', package_id: params[:id], delivery_id: params[:delivery_id]) }, status: :not_found # 404
    end
  end

  def destroy
    ensure_delivery; return if performed?

    if package = current_delivery.packages.find_by(id: params[:id])
      service = DestroyPackage.call(package)

      if service.success?
        render json: { package: package.id }, status: :ok # 200
      else
        render json: { error: service.errors }, status: :unprocessable_entity # 422
      end
    else
      render json: { error: I18n.t('errors.not_found.package', package_id: params[:id], delivery_id: params[:delivery_id]) }, status: :not_found # 404
    end
  end

  private

  def create_packages_params
    params.permit(
      packages: [
        :quantity,
        :weigth,
        :volume,
        :fragile,
        :cooling,
        :description
      ]
    )
  end

  def update_package_params
    params.permit(
      :quantity,
      :weigth,
      :volume,
      :fragile,
      :cooling,
      :description
    )
  end

end
