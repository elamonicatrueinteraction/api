module Notifications
  class InstitutionNotificationBuilder
    include ShipperApi
    def initialize(institution)
      @institution = institution
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
          network_id: @institution.network_id,
          service: "soup_kitchen"
      }.as_json
    end
  end
end
