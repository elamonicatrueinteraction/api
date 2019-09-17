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

require 'rails_helper'

RSpec.describe Package, type: :model do
  it { is_expected.to belong_to(:delivery) }
  it { is_expected.to have_one(:order).through(:delivery) }

  it { is_expected.to respond_to(:size).with(0).argument }
  it { expect(subject.size).to eq('m') }
end
