# Script para agregar el campo payment_method a los Payments. Antes no se guardaba
# para eso hay que ver el campo 'payment_method_id' en el gateway_data de Mercadopago.
# Los payments se dividen en 4 según el contenido de su gateway_data:
#
# 1. Los que tienen el campo "response" que contiene toda la gateway_data y tienen el payment_method_id
# 2. Los que tienen el campo "response" que contiene toda la gateway_data y no tienen el payment_method_id
# 3. Los que tienen el gateway_data en el primer nivel del hash de respuesta y tienen el payment_method_id
# 4. Los que tienen el gateway_data en el primer nivel del hash de respuesta y no tienen el payment_method_id
#
# A los grupos 2 y 4 se les va a asiganr PAGOFACIL como método de pago. El payment_method solo se utiliza
# para crear cupones. No se usa para ninguna operación. Como ya fueron creados entonces podemos 'obviar'
# el payment_method y asignarle o PAGOFACIL o RAPIPAGO

with_response_and_payment_method = Payment.all.select { |x| x.gateway_data['response'] }
                                     .select { |x| x.gateway_data['response']['payment_method_id'] }
with_response_and_no_payment_method = Payment.all.select { |x| x.gateway_data['response'] }
                                     .select { |x| x.gateway_data['response']['payment_method_id'].nil? }
without_response_and_with_payment_method = Payment.all.select { |x| x.gateway_data['response'].nil? }
                                     .select { |x| x.gateway_data['response']['payment_method_id'] }
without_response_and_payment_method = Payment.all.select { |x| x.gateway_data['response'].nil? }
                                     .select { |x| x.gateway_data['response']['payment_method_id'].nil? }
with_response_and_payment_method.each do |payment|
  payment_method = payment.gateway_data['response']['payment_method_id']
  payment.payment_method = payment_method
  payment_method.save!
end

without_response_and_with_payment_method.each do |payment|
  payment_method = payment.gateway_data['payment_method_id']
  payment.payment_method = payment_method
  payment_method.save!
end

with_response_and_no_payment_method.each do |payment|
  payment_method = Payment::PaymentTypes::PAGOFACIL
  payment.payment_method = payment_method
  payment.save!
end

without_response_and_payment_method.each do |payment|
  payment_method = Payment::PaymentTypes::PAGOFACIL
  payment.payment_method = payment_method
  payment.save!
end