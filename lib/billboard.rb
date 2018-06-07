module Billboard
  extend self

  SHIPPER_RANKING_ZSET = "billboard:shippers:ranking".freeze
  private_constant :SHIPPER_RANKING_ZSET

  SHIPPER_ASSIGNMENT_ZSET = "billboard:shippers:assigments".freeze
  private_constant :SHIPPER_ASSIGNMENT_ZSET

  SHIPPER_QUEUE_LIST = "billboard:shippers:queue".freeze
  private_constant :SHIPPER_QUEUE_LIST

  SHIPPER_IN_QUEUE_SET = "billboard:shippers:queue:set".freeze
  private_constant :SHIPPER_IN_QUEUE_SET

  def next_in_line
    shipper_id = $redis.lpop(SHIPPER_QUEUE_LIST)
    if shipper_id.present?
      $redis.rpush(SHIPPER_QUEUE_LIST, shipper_id)
      return shipper_id
    else
      recreate
      next_in_line
    end
  end

  def move_to_tail(shipper)
    shipper_id = shipper.id
    if $redis.lrem(SHIPPER_QUEUE_LIST, 0, shipper_id) > 0
      $redis.rpush(SHIPPER_QUEUE_LIST, shipper_id)
    end
  end

  def add_shipper_to_queue(shipper_id)
    return if $redis.sismember(SHIPPER_IN_QUEUE_SET, shipper_id)

    $redis.rpush(SHIPPER_QUEUE_LIST, shipper_id)
    $redis.sadd(SHIPPER_IN_QUEUE_SET, shipper_id)
  end

  def update_assignment_scores(shipper)
    shippers = shipper.is_a?(Enumerable) ? shipper : Array.new([shipper])

    shippers.each do |_shipper|
      $redis.zincrby(SHIPPER_ASSIGNMENT_ZSET, 1, _shipper.id)
    end
  end

  def update_ranking_scores(trip, shipper)
    $redis.sadd( trips_set(trip), shipper.id)
    $redis.sadd( shippers_set(shipper), trip.id )

    $redis.zincrby(SHIPPER_RANKING_ZSET, 1, shipper.id)
  end


  private

  def recreate
    $redis.del(SHIPPER_RANKING_ZSET)
    $redis.del(SHIPPER_ASSIGNMENT_ZSET)
    $redis.del(SHIPPER_QUEUE_LIST)

    Shipper.with_android_device_tokens.preload(:trips, :trip_assignments).find_each do |shipper|
      trips_ids = shipper.trips.pluck(:id)
      trip_assignments_ids = shipper.trip_assignments.pluck(:id)

      $redis.sadd( shippers_set(shipper), trips_ids ) if trips_ids.present?
      $redis.zadd(SHIPPER_RANKING_ZSET, trips_ids.size.to_f, shipper.id)
      $redis.zadd(SHIPPER_ASSIGNMENT_ZSET, trip_assignments_ids.size.to_f, shipper.id)
    end

    Trip.preload(:shipper, :trip_assignments).find_each do |trip|
      shippers_ids = trip.trip_assignments.where(state: ['assigned', 'broadcasted']).pluck(:shipper_id)
      $redis.sadd( trips_set(trip), shippers_ids) if shippers_ids.present?
    end

    shipper_ids = $redis.zrange(SHIPPER_RANKING_ZSET, 0,  -1)

    if shipper_ids.present?
      $redis.rpush( SHIPPER_QUEUE_LIST, shipper_ids )
      $redis.sadd( SHIPPER_IN_QUEUE_SET, shipper_ids )
    end
  end

  def shippers_set(shipper)
    "billboard:shippers:#{shipper.id}:trips"
  end

  def trips_set(trip)
    "billboard:trips:#{trip.id}:shippers"
  end

end
