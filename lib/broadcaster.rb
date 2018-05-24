module Broadcaster
  extend self

  def shippers_for(trip)
    [ Shipper.all.sample ]
  end
end
