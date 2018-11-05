class Institution < UserApiResource
  # has_many :addresses, dependent: :nullify
  has_many :users

  # Because the Address is an ApplicationRecord we need to do this
  # instead of using has_many :addresses
  def addresses
    @addresses ||= Addresses.where(institution_id: id)
  end
end
