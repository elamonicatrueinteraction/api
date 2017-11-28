require 'rails_helper'

RSpec.describe Profile, type: :model do
  # Association test
  # ensure a profile record belongs to a single user record
  it { is_expected.to belong_to(:user) }
end
