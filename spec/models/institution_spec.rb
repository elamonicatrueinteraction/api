require 'rails_helper'

RSpec.describe Institution, type: :model do
  it { should have_many(:addresses) }
end
