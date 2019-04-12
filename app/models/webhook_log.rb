# == Schema Information
#
# Table name: webhook_logs
#
#  id           :bigint(8)        not null, primary key
#  service      :string
#  path         :string(1024)
#  parsed_body  :jsonb
#  ip           :string
#  user_agent   :string
#  requested_at :datetime
#

class WebhookLog < ApplicationRecord
  attribute :parsed_body, :jsonb, default: {}
end
