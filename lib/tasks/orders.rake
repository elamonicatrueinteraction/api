
namespace :orders do
  namespace :marketplace do
    desc 'Import packages weight from marketplace'
    task "import_weight_from_marketplace" => :environment do
      Rails.logger = Logger.new(STDOUT)
      Rails.logger.info "Starting to import weights"

      orders = Order.marketplace.joins(:packages).where(packages: { weight: 0 })
      remote_order_ids = orders.map(&:marketplace_order_id)
      Rails.logger.info "Total: #{orders.count}"
      next if orders.empty?
      marketplace_orders = MarketplaceOrder.where(ids: remote_order_ids)

      Rails.logger.info "Retrieved #{marketplace_orders.count} orders from marketplace"

      orders.each do |order|
        Rails.logger.info "Processing order #{order.id} with #{order.packages.count} packages"
        Rails.logger.info "Corresponding to #{order.marketplace_order_id} marketplace order"
        marketplace_order = marketplace_orders.find { |k| k.id == order.marketplace_order_id }
        Rails.logger.info "Marketplace order found"

        order.packages.each do |package|
          Rails.logger.info "Processing package #{package.id} with #{package.weight.inspect} weight"
          weight = marketplace_order.order_items.sum { |k| k.total_weight.to_f }
          package.update(weight: weight)

          Rails.logger.info "Ok package #{package.id} with #{package.reload.weight.inspect} weight"
        end
      end
    end
  end
end
