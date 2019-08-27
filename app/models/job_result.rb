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

class JobResult < ApplicationRecord
  module Types
    FAILED = "failed".freeze
    SUCCESSFUL = "succesful".freeze
  end
end
