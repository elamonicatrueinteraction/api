module Gateway
  class RemoteNotFoundQuery
    prepend Service::Base

    def call
      payments_with_not_found_remote
    end

    private

    def payments_with_not_found_remote
      Payment.where(status: "404").select { |x| x.gateway_data["status"] == "404" }
    end
  end
end