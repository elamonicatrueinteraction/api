class V2::PaymentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :payable_id, :payable_type, :status, :amount,
             :collected_amount, :comment
end
