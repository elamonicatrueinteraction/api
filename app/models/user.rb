class User < ApplicationRecord
  has_secure_password

  has_one :profile

  validates_presence_of :email, :password_digest
end
