require 'rails_helper'

RSpec.describe PurchaseGroups, type: :model do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:owner_id) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:specifications) }
end
