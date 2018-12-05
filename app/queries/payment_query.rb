class PaymentQuery
  include Querifier::Queries::Default

  def initialize(params)
    super
    default_institution_id!
  end

  where_attributes :id, :institution_id
  order_attributes :id

  def filter_by_institution_id(value)
    @collection = @collection.where(
      payable_id: Order.by_institution_id(value).ids
    )
  end

  private

  def default_institution_id!
    return unless @params[:institution_id]

    filter_params.merge! institution_id: @params[:institution_id]
  end
end
