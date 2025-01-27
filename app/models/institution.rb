class Institution < UserApiResource
  # has_many :addresses, dependent: :nullify
  has_many :users # rubocop:disable Rails/HasManyOrHasOneDependent

  # Because the Address is an ApplicationRecord we need to do this
  # instead of using has_many :addresses
  def addresses
    @addresses ||= Services::Address.where(institution_id: id)
  end
end
