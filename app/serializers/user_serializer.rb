class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :username,
    :email,
    :active,
    :confirmed,
    :last_login_ip,
    :last_login_at,
    :profile

  def profile
    {
      first_name: object.profile.first_name,
      last_name: object.profile.last_name,
      cellphone: object.profile.cellphone
    }
  end

end

