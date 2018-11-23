class Verification < ApplicationRecord
  default_scope_by_network
  self.inheritance_column = 'type_of'

  attribute :data, :jsonb, default: {}

  validates_presence_of :data

  belongs_to :verificable, polymorphic: true, optional: true

  DATA = %w[
    type
    information
  ].freeze
  private_constant :DATA

  DATA.each do |data_key|
    attribute :"#{data_key}"

    define_method :"#{data_key}" do
      _data = (self.data || {})
      _data[data_key]
    end

    define_method :"#{data_key}=" do |new_value|
      self.data[data_key] = new_value
    end
  end

  def verified?
    not verified_at.blank?
  end

  def expired?
    !!expire && expire_at < Time.now
  end

  def responsible
    return unless verified?

    User.find_by(id: verified_by)
  end
end
