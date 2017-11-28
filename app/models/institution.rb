class Institution < ApplicationRecord
  has_many :addresses

  VALID_TYPES = %w(
    company
    organization
  ).freeze
  private_constant :VALID_TYPES

  # I place this like this because of the discussion in here:
  # https://github.com/bbatsov/ruby-style-guide/issues/328
  # I think that make sense to call methods on every Class or Instance
  # But still open to discussion
  def self.valid_types
    VALID_TYPES
  end

  def type_name
    @type_name ||= self.class.name.demodulize.downcase
  end
end
