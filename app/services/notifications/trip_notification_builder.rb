module Notifications
  class TripNotificationBuilder

    attr_reader :network_id

    def initialize(assignments:, network_id:)
      @assignments = assignments
      @network_id = network_id
    end

    def build

      shipper_ids = @assignments.map(&:shipper_id).uniq

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