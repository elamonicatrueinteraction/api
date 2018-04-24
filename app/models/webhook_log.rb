class WebhookLog < ApplicationRecord
  attribute :parsed_body, :jsonb, default: {}
end
