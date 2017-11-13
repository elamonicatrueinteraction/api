require 'tasks/logger'

namespace :shippify do
  namespace :shippers do

    desc 'Import all shippers from shippify'
    task import_all: :environment do
      length = 10
      request = Shippify::Dash.client.shippers(length:length)
      pages = (request["recordsFiltered"].to_f / length.to_f).ceil
      shippers_data = request['data']

      if pages > 1
        pages.times do |time|
          next if time == 0

          start = (length * time)
          request = Shippify::Dash.client.shippers(start: start, length:length)
          shippers_data += request['data']
        end
      end

      Tasks::Logger.log_run('shippify_shippers_fetch_all') do |log|
        shippers_data.each do |shipper_data|
          if shipper = Gateway::Shippify::ImportShipper.call(shipper_data).result
            print "."
            log.info "The shipper id #{shipper.id} was successfully imported from Shippify shipper id: #{shipper_data['Id']}"
          else
            print "F"
            log.info "Nothing happens with the Shippify shipper id: #{shipper_data['Id']}"
          end
        end
      end
    end

  end
end
