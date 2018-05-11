class Simple::OrderSerializer < ActiveModel::Serializer
  attributes :id,
    :expiration,
    :amount,
    :bonified_amount,
    :created_at,
    :updated_at,
    :giver,
    :receiver,
    :payments

  def giver
    institution_data(object.giver)
  end

  def receiver
    institution_data(object.receiver)
  end

  def payments
    #TO-DO: we should refactor this in order to use the PaymentSerializer instead
    object.payments
  end

  private

  def institution_data(institution)
    return {} unless institution

    {
      id: institution.id,
      name: institution.name
    }
  end
end
