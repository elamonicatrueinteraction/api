class Shipper < ApplicationRecord
  has_secure_password

  attribute :data, :jsonb, default: {}
  attribute :national_ids, :jsonb, default: {}
  attribute :devices, :jsonb, default: {}

  has_many :verifications, as: :verificable, dependent: :destroy
  has_many :bank_accounts
  has_many :milestones, through: :trips
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

# def data_defaults
#   {
#     "created_at_shippify": nil,
#     "enabled_at_shippify": nil,
#     "sent_email_invitation_shippify": false,
#     "sent_email_instructions": false,
#     "comments": nil,
#   }
# end
