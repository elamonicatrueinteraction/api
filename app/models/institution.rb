class Institution < UserApiResource
  cached_resource ttl: 24.hours.to_i
  # has_many :addresses, dependent: :nullify
  has_many :users # rubocop:disable Rails/HasManyOrHasOneDependent

  # Because the Address is an ApplicationRecord we need to do this
  # instead of using has_many :addresses
  def addresses
    @addresses ||= Address.where(institution_id: id)
  end
end
