class Simple::ShipperSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :first_name,
    :last_name,
    :email,
    :avatar_url

  def avatar_url
    ''
  end
end
