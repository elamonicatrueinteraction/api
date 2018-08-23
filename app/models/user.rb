class User < ApplicationRecord
  include Discard::Model
  has_secure_password

  has_one :profile, dependent: :destroy
  belongs_to :institution, optional: true

  validates_presence_of :email, :password_digest
end
