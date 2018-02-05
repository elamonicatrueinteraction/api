require 'tasks/logger'

namespace :shippify do
  namespace :places do

    namespace :import do

      desc 'Import all places from shippify'
      task all: :environment do
        response = Shippify::Api.client.places
        places_data = response['places']

        if places_data
          Tasks::Logger.log_run('shippify_places_import_all') do |log|
            places_data.each do |place_data|
              if address = Gateway::Shippify::ImportPlace.call(place_data).result
                print "."
                log.info "The Address id #{address.id} was successfully imported from Shippify place id: #{place_data['id']}"
              else
                print "F"
                log.info "Nothing happens with the Shippify place id: #{place_data['id']}"
              end
            end
          end
        else
          print "There are no places in the this Shippify Account. Response: #{response}"
        end
      end

    end
  end
end
