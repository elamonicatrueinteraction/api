namespace :maintenance do

  namespace :orders do

    desc 'Purge orphans Orders (That does not belong to any trip)'
    task "purge:orphans" => :environment do
      orders = Order.joins(:deliveries).where(deliveries: { trip_id: nil })

      orders.each do |order|
        DestroyOrder.call(order)
      end
    end
  end
end

