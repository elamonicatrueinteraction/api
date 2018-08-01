module Exporters
  class Trips < Base

    HEADER = [
      I18n.t('exporters.trip.id'),
      I18n.t('exporters.trip.status'),
      I18n.t('exporters.trip.created_at'),
      I18n.t('exporters.shipper.name'),
      I18n.t('exporters.packages.kg.cooled'),
      I18n.t('exporters.packages.kg.groceries'),
      I18n.t('exporters.packages.kg.regular'),
      I18n.t('exporters.packages.kg.total'),
      I18n.t('exporters.delivery.amount'),
      I18n.t('exporters.trip.amount'),
      I18n.t('exporters.delivery.refrigerated'),
      I18n.t('exporters.order.amount'),
      I18n.t('exporters.giver.name'),
      I18n.t('exporters.receiver.name'),
      I18n.t('exporters.trip.net_income'),
      I18n.t('exporters.order.payment'),
      I18n.t('exporters.delivery.payment')
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
        trip.created_at,
        shipper.try(:name),
        cooled_weight(delivery),
        groceries_weight(delivery),
        regular_weight(delivery),
        total_weight(delivery),
        delivery.total_amount,
        trip.amount.to_f,
        delivery.options['refrigerated'],
        order.amount.to_f,
        giver.name,
        receiver.name,
        trip.net_income,
        order.is_paid?,
        delivery.is_paid?
      ]
    end

    def cooled_weight(delivery)
      # TO-DO: We should improve the way we are dealing with this situation,
      # maybe consider to add a type field or something like that in order to
      # be more consistant with this.
      sum_packages_weight(delivery.packages, 'frescos y congelados')
    end

    def groceries_weight(delivery)
      # TO-DO: We should improve the way we are dealing with this situation,
      # maybe consider to add a type field or something like that in order to
      # be more consistant with this.
      sum_packages_weight(delivery.packages, 'frutas o verduras')
    end

    def regular_weight(delivery)
      # TO-DO: We should improve the way we are dealing with this situation,
      # maybe consider to add a type field or something like that in order to
      # be more consistant with this.
      sum_packages_weight(delivery.packages, 'no perecederos')
    end

    def total_weight(delivery)
      delivery.packages.map(&:weight).sum
    end

    def sum_packages_weight(packages, package_type)
      packages.map do |package|
        package.weight if package.description.downcase == package_type
      end.compact.sum
    end

  end
end
