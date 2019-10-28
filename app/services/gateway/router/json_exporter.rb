module Gateway
  module Router
    class JsonExporter

      def initialize(router: GatewayRouter.new)
        @router = router
      end

      def export
        routes = @router.routes
        routes.map {|rule, routed| route_entry(rule, routed)}
      end

      private

      def route_entry(rule, routed)
        {
          rule: {
            payable_type: rule.payable_type,
            networks: rule.networks,
            payment_types: rule.payment_types
          },
          payee: routed.payee
        }
      end
    end
  end
end