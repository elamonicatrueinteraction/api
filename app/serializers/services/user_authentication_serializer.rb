class Services::UserAuthenticationSerializer < UserSerializer
  attributes :password_digest
end

