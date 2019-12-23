# == Schema Information
#
# Table name: packages
#
#  id            :bigint           not null, primary key
#  delivery_id   :integer
#  weight        :integer
#  volume        :integer
#  cooling       :boolean          default(FALSE)
#  description   :text
#  attachment_id :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer          default(1)
#  fragile       :boolean          default(FALSE)
#  network_id    :string
#

class Package < ApplicationRecord
  default_scope_by_network
  belongs_to :delivery
  has_one :order, through: :delivery

  def size
    'm' # TO-DO: We should think how we want to deal with this
  end
end
