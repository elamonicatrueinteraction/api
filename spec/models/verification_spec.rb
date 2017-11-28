require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { is_expected.to belong_to(:verificable) }
end
