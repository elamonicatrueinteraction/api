module Domain
  class AuthResponse
    include ActiveModel::Model

    attr_accessor :id, :username, :email, :active, :confirmed, :last_login_ip, :last_login_at, :token_expire_at,
                  :institution_id, :profile, :networks, :roles_mask, :cities, :last_order_at, :tdu_accepted
  end
end