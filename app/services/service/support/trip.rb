module Service
  module Support
    module Trip

      private

      def load_shipper(id)
        if shipper = Shipper.find_by(id: id)
          shipper
        else
          errors.add(:type, I18n.t("services.create_trip.shipper.missing_or_invalid", id: id)) && nil
        end
      end

    end
  end
end
