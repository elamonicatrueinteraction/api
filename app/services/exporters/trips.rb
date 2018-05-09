module Exporters
  class Trips < Base

    HEADER = [
      I18n.t('exporters.trip.id'),
      I18n.t('exporters.trip.status'),
      I18n.t('exporters.trip.comments'),
      I18n.t('exporters.trip.gateway'),
      I18n.t('exporters.trip.gateway_id'),
      I18n.t('exporters.trip.created_at'),
      I18n.t('exporters.trip.updated_at'),
      I18n.t('exporters.trip.pickup'),
      I18n.t('exporters.trip.dropoff'),
      I18n.t('exporters.shipper.id'),
      I18n.t('exporters.shipper.name'),
      I18n.t('exporters.shipper.email'),
      I18n.t('exporters.delivery.id'),
      I18n.t('exporters.delivery.amount'),
      I18n.t('exporters.delivery.status'),
      I18n.t('exporters.delivery.gateway'),
      I18n.t('exporters.delivery.gateway_id'),
      I18n.t('exporters.delivery.refrigerated'),
      I18n.t('exporters.delivery.origin_id'),
      I18n.t('exporters.delivery.origin_address'),
      I18n.t('exporters.delivery.destination_id'),
      I18n.t('exporters.delivery.destination_address'),
      I18n.t('exporters.order.id'),
      I18n.t('exporters.order.amount'),
      I18n.t('exporters.giver.id'),
      I18n.t('exporters.giver.name'),
      I18n.t('exporters.receiver.id'),
      I18n.t('exporters.receiver.name'),
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

        trip.deliveries.each do |delivery|
          yield row_data(trip, delivery)
        end

      end
    end

    def row_data(trip, delivery)
      shipper = trip.shipper
      order = delivery.order
      giver = order.giver
      receiver = order.receiver

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
        shipper.id,
        shipper.name,
        shipper.email,
        trip.steps[0]['delivery_id'],
        delivery.amount,
        delivery.status,
        delivery.gateway,
        delivery.gateway_id,
        delivery.options['refrigerated'],
        delivery.pickup.dig(:address, :id),
        lookup_address(delivery.pickup[:address]),
        delivery.dropoff.dig(:address, :id),
        lookup_address(delivery.dropoff[:address]),
        delivery.order_id,
        order.amount.to_f,
        giver.id,
        giver.name,
        receiver.id,
        receiver.name
      ]
    end

    def lookup_address(address_hash)
      address_hash ||= {}

      [
        address_hash[:street_1],
        [address_hash[:zip_code], address_hash[:city]].compact.join(' '),
        address_hash[:state],
        address_hash[:country]
      ].compact.join(', ')
    end
  end
end
