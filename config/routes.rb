Rails.application.routes.draw do


  root to: 'home#show'

# ╭─ Public Accesible URL's / Path's
  post 'authenticate', action: :authenticate, controller: :authentication, protocol: SECURE_PROTOCOL
  resources :shippers, only: [:show, :create, :update], protocol: SECURE_PROTOCOL
# ╰─ End of Public Accesible URL's / Path's

end



# User.create!(username: 'cavi', email: 'cavi@nilus.org' , password: 'nadanada' , password_confirmation: 'nadanada')
