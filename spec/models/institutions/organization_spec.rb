require 'rails_helper'

RSpec.describe Institutions::Organization, type: :model do
  it { is_expected.to have_many(:addresses) }
end
