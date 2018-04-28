class MilestoneSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :latlng,
    :comments,
    :created_at
end



