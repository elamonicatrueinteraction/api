module Gateway
  class RemoteNotFoundQuery
    prepend Service::Base

    def call
      payments_with_not_found_remote
    end

    private

    def payments_with_not_found_remote
      Payment.where(status: Payment::Types::PENDING).select { |x| x.gateway_data["when_searched_with_all_tokens_got"] == "404" }
    end
  end
end