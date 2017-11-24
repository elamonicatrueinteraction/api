module Service
  module Support
    module Address

      private

      def address_params(allowed_params)
        allowed_params.tap do |_params|
          _params[:gps_coordinates] = valid_coordinate_point(_params[:latlng]) if _params[:latlng]
        end
      end

      def valid_coordinate_point(data)
        lat, lng = data.split(',')
        "POINT (#{lng} #{lat})"
      end

    end
  end
end
