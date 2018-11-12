class Package < ApplicationRecord
  belongs_to :delivery
  has_one :order, through: :delivery

  def size
    'm' # TO-DO: We should think how we want to deal with this
  end
end
