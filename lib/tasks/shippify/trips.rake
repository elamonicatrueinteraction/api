require 'tasks/logger'

namespace :shippify do
  namespace :trips do

    namespace :import do

      desc "Import today's trips from shippify"
      task today: :environment do
        length = 10
        request = Shippify::Dash.client.trips(length:length)
        pages = (request["recordsFiltered"].to_f / length.to_f).ceil
        trips_data = request['data']

        if pages > 1
          pages.times do |time|
            next if time == 0

            start = (length * time)
            request = Shippify::Dash.client.trips(start: start, length:length)
            trips_data += request['data']
          end
        end

        Tasks::Logger.log_run('shippify_trips_import_today') do |log|
          trips_data.each do |trip_data|
            trip_id = trip_data['id']
            service = Gateway::Shippify::ImportTrip.call(trip_id)

            if service.success?
              trip = service.result
              print "."
              log.info "The trip id #{trip.id} was successfully imported from Shippify delivery id: #{trip_id}"
            else
              print "F"
              log.info "Nothing happens with the Shippify delivery id: #{trip_id}. Errors: #{service.errors}"
            end
          end
        end
      end

      desc 'Import this month trips from shippify'
      task month: :environment do
        length = 10
        request = Shippify::Dash.client.trips(length:length, period: 'month')
        pages = (request["recordsFiltered"].to_f / length.to_f).ceil
        trips_data = request['data']

        if pages > 1
          pages.times do |time|
            next if time == 0

            start = (length * time)
            request = Shippify::Dash.client.trips(start: start, length:length, period: 'month')
            trips_data += request['data']
          end
        end

        Tasks::Logger.log_run('shippify_trips_import_month') do |log|
          trips_data.each do |trip_data|
            trip_id = trip_data['id']
            service = Gateway::Shippify::ImportTrip.call(trip_id)

            if service.success?
              trip = service.result
              print "."
              log.info "The trip id #{trip.id} was successfully imported from Shippify delivery id: #{trip_id}"
            else
              print "F"
              log.info "Nothing happens with the Shippify delivery id: #{trip_id}. Errors: #{service.errors}"
            end
          end
        end
      end

      desc 'Import all the trips from shippify'


    end
  end
end
