module Tenant
  class ShouldMakeOrderCouponRule

    def should_make?(order)
      # Aclaración: si bien solo bastaría con que chequear que el giver sea el BAR, hay algunos lados de la aplicación
      # que llama que hace que las ordenes pertenezcan a MDQ pero figure como dador el BAR.
      # A falta de test automatizado para revisar esto siempre se hace este chanchuyo que garantiza que no se rompa
      # @author: Tom.
      order.giver.name != 'BAR' || order.network_id == 'MDQ'
    end
  end
end