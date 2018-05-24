class TripDispatch
  attr_reader :trip, :shipper

  def initialize(trip, shipper = nil)
    @trip = trip
    @shipper = shipper
    self
  end

  def errors
    @errors ||= Service::Errors.new
  end

  def success?
    !failure?
  end

  def failure?
    errors.any?
  end

  def assign!
    begin
      TripAssignment.transaction do
        # Pessimistic Locking in order to prevent race-conditions
        trip.lock!

        if assignable?
          @assignment = TripAssignment.create!(
            state: 'assigned',
            trip: trip,
            shipper: shipper
          )

          trip.assign_attributes(status: 'waiting_shipper')
          trip.save!
        else
          raise Service::Error.new(self)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => exception
      errors.add_multiple_errors( exception.record.errors.messages ) if exception.is_a?(ActiveRecord::RecordInvalid)
    end

    Notifications::PushWorker.perform_async(@assignment.id) if success?

    self
  end

  def broadcast!
    assignments = {}
    begin
      shippers = Broadcaster.shippers_for(trip)

      TripAssignment.transaction do
        # Pessimistic Locking in order to prevent race-conditions
        trip.lock!

        if broadcastable?
          shippers.each do |_shipper|
            assignments[_shipper.id] = TripAssignment.create!(
              state: 'broadcasted',
              trip: trip,
              shipper: _shipper
            )
          end

          trip.assign_attributes(status: 'waiting_shipper')
          trip.save!
        else
          raise Service::Error.new(self)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => exception
      errors.add_multiple_errors( exception.record.errors.messages ) if exception.is_a?(ActiveRecord::RecordInvalid)
    end

    if success?
      shippers.each do |_shipper|
        assignment_id = assignments[_shipper.id].id
        Notifications::PushWorker.perform_async(assignment_id)
      end
    end

    self
  end

  def take!
    begin
      TripAssignment.transaction do
        # Pessimistic Locking in order to prevent race-conditions
        trip.lock!

        if takable?
          now = Time.current

          @open_assignments.each do |assignment|
            assignment.update!(closed_at: now)
          end

          TripAssignment.create!(
            state: 'accepted',
            trip: trip,
            shipper: shipper,
            closed_at: now
          )

          trip.update!(shipper: shipper, status: 'confirmed')
        else
          raise Service::Error.new(self)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => exception
      errors.add_multiple_errors( exception.record.errors.messages ) if exception.is_a?(ActiveRecord::RecordInvalid)
    end

    self
  end

  private

  def assignable?
    return true if trip.status.blank?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_assign_trip')) && false
  end

  def broadcastable?
    return true if trip.status.blank?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_broadcast_trip')) && false
  end

  def takable?
    return true if trip.status == 'waiting_shipper' && valid_open_assignments?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_take_trip')) && false
  end

  def valid_open_assignments?
    @open_assignments = TripAssignment.where(state: ['assigned', 'broadcasted'], trip: trip, shipper: shipper, closed_at: nil)

    return true if @open_assignments.present?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.no_valid_open_assignments')) && false
  end

end
