# == Schema Information
#
# Table name: packages
#
#  id            :bigint(8)        not null, primary key
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

class PackageSerializer < Simple::PackageSerializer
  belongs_to :delivery, serializer: Simple::DeliverySerializer
end
