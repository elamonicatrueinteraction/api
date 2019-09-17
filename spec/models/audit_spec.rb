# == Schema Information
#
# Table name: audits
#
#  id             :uuid             not null, primary key
#  model          :string
#  message        :string
#  field          :string
#  original_value :string
#  new_value      :string
#  user_id        :uuid
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Audit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
