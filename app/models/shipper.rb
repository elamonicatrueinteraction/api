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

class Shipper < ApplicationRecord
  default_scope_by_network
  has_secure_password

  attribute :data, :jsonb, default: {}
  attribute :national_ids, :jsonb, default: {}

  # TO-DO: We should remove this logic from here
  attribute :devices, :jsonb, default: {}

  scope :with_android_device_tokens, -> { where("devices->>'android' IS NOT NULL") }
  scope :verified, -> { where(verified:true)}

  has_many :verifications, as: :verificable, dependent: :destroy
  has_many :bank_accounts
  has_many :milestones, through: :trips
  has_many :trip_assignments, dependent: :destroy
  has_many :trips, dependent: :nullify
  has_many :vehicles, dependent: :destroy

  validates_presence_of :first_name, :email, :password_digest

  DEFAULT_REQUIREMENT_TEMPLATE = {
    'verified' => false,
    'uri' => nil,
    'data' => {},
    'expiration_date' => ''
  }.freeze

  REQUIREMENTS = %w(
    habilitation_transport_food
    sanitary_notepad
  ).freeze

  MINIMUM_REQUIREMENTS = %w(
    driving_license
    is_monotributista
    has_cuit_or_cuil
    has_banking_account
    has_paypal_account
  ).freeze

  def full_name
    @full_name ||= [first_name, last_name].join(' ').strip
  end
  alias :name :full_name

  # TO-DO: We should remove this logic from here
  def has_device?(device_hash = {})
    type, token = device_hash.fetch_values(:type, :token)

    return false unless devices.keys.include?(type)

    devices[type].key?(token)
  end

  def requirements
    REQUIREMENTS.each_with_object({}) do |requirement, _hash|
      _hash[requirement] = DEFAULT_REQUIREMENT_TEMPLATE
    end.deep_merge(attributes['requirements'].to_h)
  end

  def minimum_requirements
    MINIMUM_REQUIREMENTS.each_with_object({}) do |requirement, _hash|
      _hash[requirement] = DEFAULT_REQUIREMENT_TEMPLATE
    end.deep_merge(attributes['minimum_requirements'].to_h)
  end
end
