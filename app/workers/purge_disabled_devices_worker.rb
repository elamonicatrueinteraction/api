class PurgeDisabledDevicesWorker
  include Sidekiq::Worker

  def perform(shipper_id, disabled_devices)
    shipper = Shipper.find(shipper_id)

    valid_android_devices = (shipper.devices[:android] || {}).delete_if do |key,_|
      key.blank? || disabled_devices.include?(key)
    end

    shipper.devices[:android] = valid_android_devices
    shipper.save! if shipper.changed?
  end
end
