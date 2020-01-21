module Notifications
  class InstitutionNotificationBuilder
    include ShipperApi

    attr_reader :network_id

    def initialize(institution, network_id:)
      @institution = institution
      @network_id = network_id
    end

    def build
      {
          notification: {
              title: "Tu pedido está en camino",
              body: "Entregaremos la mercadería en la próxima hora",
              receiver_ids: [@institution.id],
              data: {
                  in_app_title: "Tu pedido está en camino",
                  in_app_body: "Entregaremos la mercadería en la próxima hora. Por favor asegurate de que haya alguien en el domicilio para recibir la entrega y ayudar con la descarga."
              },
          },
          service: "soup_kitchen"
      }.as_json
    end
  end
end
