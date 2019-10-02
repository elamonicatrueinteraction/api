class PaymentQuery
  include Querifier::Queries::Default

  def initialize(params)
    super
    default_institution_id!
  end

  where_attributes :id, :institution_id
  order_attributes :id

  def filter_by_institution_id(value)
    order_ids = Order.unscoped.by_receiver_id(value).ids
    activity_ids = UntrackedActivity.by_institution_id(value).ids
    @collection = @collection.where(
      payable_id: [*order_ids, *activity_ids,*Delivery.unscoped.where(order_id: order_ids).ids]
    )
  end

  def self.default_collection
    Payment.unscoped.all
  end

  private

  def default_institution_id!
    return unless @params[:institution_id]

    filter_params.merge! institution_id: @params[:institution_id]
  end
end
