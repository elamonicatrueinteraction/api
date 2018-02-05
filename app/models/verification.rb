class Verification < ApplicationRecord
  self.inheritance_column = 'type_of'

  attribute :data, :jsonb, default: {}

  validates_presence_of :data

  belongs_to :verificable, polymorphic: true, optional: true

  attribute :type
  def type
    data[:type]
  end
  def type=(new_value)
    self.data[:type] = new_value
  end

  attribute :information
  def information
    data[:information]
  end
  def information=(new_value)
    self.data[:information] = new_value
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
