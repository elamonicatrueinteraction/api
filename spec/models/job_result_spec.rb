# == Schema Information
#
# Table name: job_results
#
#  id         :uuid             not null, primary key
#  name       :string
#  result     :string
#  message    :string
#  extra_info :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe JobResult, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
