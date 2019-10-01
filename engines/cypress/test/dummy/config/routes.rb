Rails.application.routes.draw do
  mount Cypress::Engine => "/cypress"
end
