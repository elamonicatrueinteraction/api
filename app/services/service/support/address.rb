module Service
  module Support
    module Address

      private

      def address_params(allowed_params, update = false)
        allowed_params.tap do |_params|
          if _params[:latlng]
            _params[:gps_coordinates] = valid_coordinate_point(_params[:latlng])
          else
            errors.add(:type, I18n.t("services.address.latlng.missing")) unless update
          end
        end
      end

      def valid_coordinate_point(data)
        lat, lng = data.split(',')
        "POINT (#{lng} #{lat})"
      end

    end
  end
end
