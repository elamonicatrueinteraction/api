module Service
  module Support
    module Delivery

      private

      def load_address(action, id)
        if address = ::Address.find_by(id: id)
          address
        else
          id = id.blank? ? '(empty)' : id
          errors.add(:type, I18n.t("services.create_delivery.#{action}.missing_or_invalid", id: id)) && nil
        end
      end

      def params_status_or_default(params_status, actual_status = nil)
        return params_status if params_status && ::Delivery.valid_status.include?(params_status.to_s)

        actual_status ? actual_status : ::Delivery.default_status
      end

    end
  end
end
