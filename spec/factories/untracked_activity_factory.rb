# == Schema Information
#
# Table name: untracked_activities
#
#  id             :uuid             not null, primary key
#  institution_id :uuid
#  author_id      :uuid
#  reason         :string
#  activity       :string
#  amount         :decimal(12, 4)   default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  network_id     :string
#

#  id               :uuid             not null, primary key
#  institution_id   :uuid
#  author_id        :uuid
#  amount           :decimal(12, 4)   default(0.0)
#  reason           :string
#  activity           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  network_id       :string
#

FactoryBot.define do
  factory :untracked_activity do
    amount { 200 }
    activity { UntrackedActivity::Types::ORDER }
    institution_id { Institution.all.sample.id }
    network_id { 'ROS' }
    author_id { User.all.sample.id }
    reason {'Unknown reason'}

    trait :with_pending_payment do
      after(:create) do |untracked, evaluator|
        create(:payment, payable: untracked, amount: untracked.amount)
      end
    end

    trait :with_delivery_as_activity do
      activity { UntrackedActivity::Types::DELIVERY }
    end
  end
end
