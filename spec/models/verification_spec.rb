require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { should belong_to(:verificable) }
end
