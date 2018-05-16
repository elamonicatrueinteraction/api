module Exporters
  class Trips < Base

    HEADER = [
      I18n.t('exporters.trip.id'),
      I18n.t('exporters.trip.status'),
      I18n.t('exporters.trip.gateway_id'),
      I18n.t('exporters.trip.created_at'),
      I18n.t('exporters.shipper.name'),
      I18n.t('exporters.delivery.amount'),
      I18n.t('exporters.delivery.refrigerated'),
      I18n.t('exporters.order.amount'),
      I18n.t('exporters.giver.name'),
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
        trip.gateway_id,
        trip.created_at,
        shipper.try(:name),
        delivery.amount,
        delivery.options['refrigerated'],
        order.amount.to_f,
        giver.name,
        receiver.name
        order.packages
      ]
    end
  end
end
