module Webhooks
  class BaseController < ApplicationController
    include ::Webhooks::Logger

    skip_before_action :authorize_request
  end
end
