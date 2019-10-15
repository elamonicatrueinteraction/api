FactoryBot.define do
  factory :payment do
    status { 'pending' }
    amount { 500 }
    payable_type { 'Order' }
    payable_id {order.id}
    gateway { 'mercadopago' }
    gateway_id { 5797753650 }
    gateway_data { { id: gateway_id, card: {}, order: {}, payer: { id: nil, type: "guest", email: nil, phone: {}, last_name: nil, first_name: nil, entity_type: nil, identification: {}}, status: "pending", barcode: { type: "Code128C", width: 1, height: 30, content: "333500880000000MP33189385314100065200181800538"}, refunds: [], acquirer: nil, captured: true, metadata: {}, issuer_id: nil, live_mode: true, sponsor_id: nil, binary_mode: false, currency_id: "ARS", description: "NILUS/BAR - Pago por la orden #172e2c60-dfa6-4861-8587-85c28349d92d", fee_details: [], collector_id: 280994634, date_created: "2018-06-29T11:40:34.000-04:00", installments: 1, coupon_amount: 0, date_approved: nil, status_detail: "pending_waiting_payment", operation_type: "regular_payment", additional_info: {}, merchant_number: nil, payment_type_id: "ticket", processing_mode: "aggregator", counter_currency: nil, deduction_schema: nil, notification_url: "https://api.nilus.org/webhooks/mercadopago/payment/bc94f6f6-7a0b-45ea-b22e-d03826b63a71", date_last_updated: "2018-06-29T11:40:34.000-04:00", payment_method_id: "pagofacil", authorization_code: nil, date_of_expiration: nil, external_reference: "bc94f6f6-7a0b-45ea-b22e-d03826b63a71", money_release_date: nil, transaction_amount: amount, merchant_account_id: nil, transaction_details: { overpaid_amount: 0, total_paid_amount: amount, verification_code: gateway_id, acquirer_reference: nil, installment_amount: 0, net_received_amount: 0, external_resource_url: "http://www.mercadopago.com/mla/payments/ticket/helper?payment_id=3877842579&payment_method_reference_id=3189385314&caller_id=321383840&hash=72e33d8e-86e1-4494-bd9c-1aa579d75a5c", financial_institution: nil, payable_deferral_period: nil, payment_method_reference_id: gateway_id}, money_release_schema: nil, statement_descriptor: nil, call_for_authorize_id: nil, acquirer_reconciliation: [], differential_pricing_id: nil, transaction_amount_refunded: 0 } }



    trait :approved do
      status { 'approved' }
      collected_amount { (amount * 0.98) }
      notifications { { "#{Date.today}" => { id: gateway_id, card: {}, order: {}, payer: { id: nil, type: "guest", email: "administracion@barosario.org", phone: { number: nil, area_code: nil, extension: nil}, last_name: "administracion", first_name: nil, entity_type: nil, identification: { type: nil, number: nil}}, status: "approved", barcode: { type: "Code128C", width: 1, height: 30, content: "333500880000000MP33189385314100065200181840534"}, refunds: [], site_id: "MLA", acquirer: nil, captured: true, metadata: {}, payer_id: 321383840, client_id: "2843879520659529", collector: { id: 280994634, email: "administracion@barosario.org.ar", phone: { number: "3415278731", area_code: " ", extension: nil}, last_name: "Asociación Civil BAR", first_name: "Banco de Alimentos Rosario", identification: { type: "Otro", number: "30712094903"}}, coupon_id: nil, issuer_id: nil, live_mode: true, payer_tags: [], profile_id: nil, reserve_id: nil, sponsor_id: nil, api_version: "2", binary_mode: false, currency_id: "ARS", description: "NILUS/BAR - Pago por la orden #172e2c60-dfa6-4861-8587-85c28349d92d", fee_details: [{ type: "mercadopago_fee", amount: 19.76, fee_payer: "collector"}], marketplace: "NONE", collector_id: 280994634, date_created: "2018-06-29T11:40:34.000-04:00", installments: 1, coupon_amount: 0, date_approved: "2018-07-03T10:35:15.000-04:00", status_detail: "accredited", application_id: 2843879520659529, collector_tags: [], financing_type: nil, operation_type: "regular_payment", transaction_id: nil, additional_info: {}, merchant_number: nil, payment_type_id: "ticket", processing_mode: "aggregator", shipping_amount: 0, counter_currency: nil, deduction_schema: nil, notification_url: "https://api.nilus.org/webhooks/mercadopago/payment/bc94f6f6-7a0b-45ea-b22e-d03826b63a71", available_actions: ["refund"], date_last_updated: "2018-07-03T10:35:15.000-04:00", internal_metadata: {}, payment_method_id: "pagofacil", risk_execution_id: nil, authorization_code: nil, date_of_expiration: nil, external_reference: "bc94f6f6-7a0b-45ea-b22e-d03826b63a71", money_release_date: "2018-07-08T10:35:15.000-04:00", money_release_days: nil, transaction_amount: amount, merchant_account_id: nil, transaction_details: { overpaid_amount: 0, total_paid_amount: amount, verification_code: gateway_id, acquirer_reference: nil, installment_amount: 0, net_received_amount: collected_amount, external_resource_url: "http://www.mercadopago.com/mla/payments/ticket/helper?payment_id=3877842579&payment_method_reference_id=3189385314&caller_id=321383840&hash=72e33d8e-86e1-4494-bd9c-1aa579d75a5c", financial_institution: nil, payable_deferral_period: nil, payment_method_reference_id: gateway_id}, money_release_schema: nil, statement_descriptor: nil, call_for_authorize_id: nil, acquirer_reconciliation: [], differential_pricing_id: nil, transaction_amount_refunded: 0} } }
    end

    trait :without_gateway_data do
      gateway { nil }
      status { nil }
      gateway_id { nil }
      gateway_data {{}}
    end

    factory :approved_payment, traits: [ :approved ]
  end
end
