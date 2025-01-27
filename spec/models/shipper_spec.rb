# == Schema Information
#
# Table name: shippers
#
#  id                   :uuid             not null, primary key
#  first_name           :string           not null
#  last_name            :string
#  gender               :string
#  birth_date           :date
#  email                :string           not null
#  phone_num            :string
#  photo                :string
#  active               :boolean          default(FALSE)
#  verified             :boolean          default(FALSE)
#  verified_at          :date
#  national_ids         :jsonb
#  gateway              :string
#  gateway_id           :string           not null
#  data                 :jsonb
#  minimum_requirements :jsonb
#  requirements         :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  password_digest      :string
#  token_expire_at      :integer
#  login_count          :integer          default(0), not null
#  failed_login_count   :integer          default(0), not null
#  last_login_at        :datetime
#  last_login_ip        :string
#  devices              :jsonb
#  network_id           :string
#

require 'rails_helper'

RSpec.describe Shipper, type: :model do
  it { is_expected.to have_many(:bank_accounts) }
  it { is_expected.to have_many(:milestones).through(:trips) }
  it { is_expected.to have_many(:trips) }
  it { is_expected.to have_many(:trip_assignments) }
  it { is_expected.to have_many(:verifications) }
  it { is_expected.to have_many(:vehicles) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it { expect(subject.class).to be_const_defined(:DEFAULT_REQUIREMENT_TEMPLATE) }
  it { expect(subject.class).to be_const_defined(:REQUIREMENTS) }
  it { expect(subject.class).to be_const_defined(:MINIMUM_REQUIREMENTS) }
  it { expect(subject.class::REQUIREMENTS).to contain_exactly('habilitation_transport_food', 'sanitary_notepad') }
  it { expect(subject.class::MINIMUM_REQUIREMENTS).to contain_exactly('driving_license', 'is_monotributista', 'has_cuit_or_cuil', 'has_banking_account', 'has_paypal_account') }

  it { is_expected.to respond_to(:full_name).with(0).argument }
  it { is_expected.to respond_to(:name).with(0).argument }
  it { is_expected.to respond_to(:has_device?).with(0..1).argument }
  it { is_expected.to respond_to(:requirements).with(0).argument }
  it { is_expected.to respond_to(:minimum_requirements).with(0).argument }
end
