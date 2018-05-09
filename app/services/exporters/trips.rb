module Exporters
  class Trips < Base

    HEADER = [
      I18n.t('exporters.trips.id'),
      I18n.t('exporters.trips.status'),
      I18n.t('exporters.trips.comments'),
      I18n.t('exporters.trips.gateway'),
      I18n.t('exporters.trips.gateway_id'),
      I18n.t('exporters.trips.created_at'),
      I18n.t('exporters.trips.updated_at'),
      I18n.t('exporters.trips.pickup'),
      I18n.t('exporters.trips.dropoff'),
      I18n.t('exporters.trips.shipper_id'),
      I18n.t('exporters.trips.delivery_id'),
      I18n.t('exporters.trips.delivery_amount'),
      I18n.t('exporters.trips.delivery_status'),
      I18n.t('exporters.trips.delivery_gateway'),
      I18n.t('exporters.trips.delivery_gateway_id'),
      I18n.t('exporters.trips.delivery_refrigerated'),
      I18n.t('exporters.trips.delivery_origin_id'),
      I18n.t('exporters.trips.delivery_origin_address'),
      I18n.t('exporters.trips.delivery_destination_id'),
      I18n.t('exporters.trips.delivery_destination_address'),
      I18n.t('exporters.trips.order_id'),
      I18n.t('exporters.trips.order_amount'),
      I18n.t('exporters.trips.giver_id'),
      I18n.t('exporters.trips.giver_name'),
      I18n.t('exporters.trips.receiver_id'),
      I18n.t('exporters.trips.receiver_name'),
    ].freeze
    private_constant :HEADER

    def initialize(options = {})
      @trips = options[:trips]
    end

    def filename
      "nilus_trips_#{Time.now.strftime('%Y-%m-%d')}"
    end

    def sheetname
      I18n.t("exporters.trips.sheetname")
    end

    def csv_stream
      Enumerator.new do |result|
        result << csv_header

        yielder do |row|
          result << csv_row(row)
        end
      end
    end

    def data_stream
      Enumerator.new do |result|
        result << header

        yielder do |row|
          result << row
        end
      end
    end

    private

    def header
      @header ||= HEADER
    end

    def csv_header
      CSV::Row.new(header, header, true).to_s
    end

    def csv_row(values)
      CSV::Row.new(header, values).to_s
    end

    def yielder
      @trips.each do |trip|
        
        yield row_data(trip)
      end
    end
    
    def row_data(trip)
      @delivery = find_delivery(trip.steps[0]['delivery_id'])
      @order = find_order(@delivery.order_id)
      @institution = find_institution(@order.giver_id)
      [
        trip.id,
        trip.status,
        trip.comments,
        trip.gateway,
        trip.gateway_id,
        trip.created_at,
        trip.updated_at,
        trip.steps[0]['action'],
        trip.steps[1]['action'],
        trip.shipper_id,
        trip.steps[0]['delivery_id'],
        @delivery.amount,
        @delivery.status,
        @delivery.gateway,
        @delivery.gateway_id,
        @delivery.options['refrigerated'],
        @delivery.pickup.dig(:address, :id),
        @delivery.pickup.dig(:address, :street_1),
        @delivery.dropoff.dig(:address, :id),
        @delivery.dropoff.dig(:address, :street_1),
        @delivery.order_id,
        @order.amount,
        @order.giver_id,
        @institution.name,
        @order.receiver_id,
        @institution.name
      ]
    end

    def find_delivery(tripId)
      @delivery = Delivery.find(tripId)
    end

    def find_order(deliveryId)
      @order = Order.find(deliveryId)
    end

    def find_institution(orderId)
      @institution = Institution.find(orderId)
    end
  end
end
