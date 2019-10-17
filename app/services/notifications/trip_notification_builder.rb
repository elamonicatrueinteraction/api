module Notifications
  class TripNotificationBuilder

    def initialize(assignments:)
      @assignments = assignments
    end

    def build
      shipper_ids = @assignments.shipper.map {|x| x.id}
      {
        notification: {
          title: "Nilus Choferes",
          body: message(@assignments.first),
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