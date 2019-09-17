
module Services
  class Institution < Services::UserService
    attributes :id, :name, :legal_name, :city, :category, :uid_type, :uid,
               :created_at, :updated_at, :beneficiaries, :offered_services,
               :network_id, :external_reference, :district, :total_debt

    has_many :users # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :addresses # rubocop:disable Rails/HasManyOrHasOneDependent

    def calculated_total_debt
      Payment.where(id: PaymentQuery.new({ institution_id: id }).collection.ids).sum('coalesce(amount, 0) - coalesce(collected_amount, 0)')
    end
  end
end
