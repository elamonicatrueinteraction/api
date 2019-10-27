module Notifications
  class TripNotificationBuilder

    def initialize(assignments:)
      @assignments = assignments
    end

    def build
      shipper_ids = []

      @assignments.each do |assignment|
        shipper_ids.push(assignment.shipper_id)
      end

      shipper_ids = shipper_ids.uniq

      {
        notification: {
          title: "Nilus Choferes",
          body: message(@assignments.first.state),
          receiver_ids: shipper_ids
        },
        service: "driver"
      }
    end

    private

    def message(state)
      message_hash[state]
    end

    def message_hash
      {
        assigned: '¡Tenés un viaje asignado en Nilus! Ingresá para aceptarlo',
        broadcasted: '¡Hay un nuevo viaje de Nilus! Ingresá para aceptarlo'
      }.with_indifferent_access
    end
  end
end