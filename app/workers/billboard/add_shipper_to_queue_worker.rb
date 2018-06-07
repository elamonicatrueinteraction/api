class AddShipperToQueueWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority

  def perform(shipper_id)
    if shipper = Shipper.with_android_device_tokens.where(id: shipper_id).last
      Billboard.add_shipper_to_queue(shipper.id)
    end
  end
end
