module Cypress
  class StatusController < ActionController::Base

    def status
      render plain: "Cypress is UP", status: 200
    end
  end
end