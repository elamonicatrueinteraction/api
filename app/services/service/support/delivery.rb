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

    end
  end
end
