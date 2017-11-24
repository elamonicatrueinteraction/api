require 'rails_helper'

RSpec.describe Institutions::Company, type: :model do
  it { should have_many(:addresses) }
end
