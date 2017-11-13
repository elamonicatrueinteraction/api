class Verification < ApplicationRecord
  attribute :data, :jsonb, default: {}

  validates_presence_of :data

  belongs_to :verificable, polymorphic: true

  def type
    data[:type]
  end

  def information
    data[:information]
  end

  def verified?
    not verified_at.blank?
  end

  def responsable
    return unless verified?

    User.find_by(id: verified_by)
  end
end
