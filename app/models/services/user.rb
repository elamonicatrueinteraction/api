module Services
  class User < Services::UserService
    attributes :id, :email, :username, :institution_id, :networks, :roles_mask,
               :cities, :active, :confirmed, :last_login_at, :profile
  end
end
