Cypress::Engine.routes.draw do

  get '/status', action: :status, controller: :status
end
