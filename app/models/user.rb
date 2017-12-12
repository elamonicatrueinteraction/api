class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy

  validates_presence_of :email, :password_digest
end
