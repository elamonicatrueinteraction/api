require 'rails_helper'

RSpec.describe Gateway::Shippify::ShipperUpdateWorker do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }
end
