module Services
  class User < Services::UserService
    include RoleModel

    attributes :id, :email, :username, :institution_id, :networks, :roles_mask,
               :cities, :active, :confirmed, :last_login_at, :profile

    belongs_to :institution
  end
end
