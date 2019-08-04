module Tenant
  class ShouldMakeOrderCouponRule

    def should_make?(order)
      # Aclaración: si bien solo bastaría con que chequear que el giver sea el BAR, hay algunos lados de la aplicación
      # que llama que hace que las ordenes pertenezcan a MDQ pero figure como dador el BAR.
      # A falta de test automatizado para revisar esto siempre se hace este chanchuyo que garantiza que no se rompa
      # @author: Tom.

      whitelisted_networks = %w(MDQ MCBA LP)
      order.giver.name != 'BAR' || whitelisted_networks.include?(order.network_id)
    end
  end
end