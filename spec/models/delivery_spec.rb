require 'rails_helper'

RSpec.describe Delivery, type: :model do
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:trip) }
  it { is_expected.to belong_to(:origin).class_name('Address') }
  it { is_expected.to belong_to(:destination).class_name('Address') }
  it { is_expected.to have_many(:packages) }
  it { is_expected.to have_many(:payments) }

  it { is_expected.to respond_to(:origin_latlng) }
  it { is_expected.to respond_to(:destination_latlng) }
end
