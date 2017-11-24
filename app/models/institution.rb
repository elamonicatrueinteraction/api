class Institution < ApplicationRecord
  has_many :addresses

  VALID_TYPES = %w(
    company
    organization
  ).freeze

  def type_name
    @type_name ||= self.class.name.demodulize.downcase
  end
end
