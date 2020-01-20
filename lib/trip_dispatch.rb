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
          trip.save! if trip.changed?

          # TO-DO: We should move all this to a BillboardHandler I think
          Billboard.move_to_tail(shipper)
          Billboard.update_assignment_scores(shipper)
        else
          raise Service::Error.new(self)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => exception
      errors.add_multiple_errors( exception.record.errors.messages ) if exception.is_a?(ActiveRecord::RecordInvalid)
    end

    Rails.logger.info "Push notification status #{success?}"
    Notifications::PushWorker.new.perform([@assignment.id], network_id: shipper.network_id) if success?

    self
  end

  def broadcast!
    assignments = {}
    begin
      shippers = Shipper.verified
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
          trip.save! if trip.changed?

          # TO-DO: We should move all this to a BillboardHandler I think
          Billboard.update_assignment_scores(shippers)
        else
          raise Service::Error.new(self)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => exception
      errors.add_multiple_errors( exception.record.errors.messages ) if exception.is_a?(ActiveRecord::RecordInvalid)
    end

    if success?
      #TO-DO: I don't like this approach but it's effective and it's clear in the intentions
      assignments_ids = shippers.map do |_shipper|
        assignments[_shipper.id].id
      end

      Notifications::PushWorker.new.perform(assignments_ids, network_id: shippers.first.network_id)

      # CheckBroadcastWorker.perform_in(2.minutes, assignments_ids)
    end

    self
  end

  def take!
    begin
      TripAssignment.transaction do
        # Pessimistic Locking in order to prevent race-conditions
        trip.lock!

        if takable? # WARNING! This method define the instance var @open_assignments. TO-DO: Improve this
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

          # TO-DO: We should move all this to a BillboardHandler I think
          Billboard.move_to_tail(shipper)
          Billboard.update_ranking_scores(trip, shipper)
        else
          raise Service::Error.new(self)
        end
      end
    rescue Service::Error, ActiveRecord::RecordInvalid => exception
      errors.add_multiple_errors( exception.record.errors.messages ) if exception.is_a?(ActiveRecord::RecordInvalid)
    end

    self
  end

  def pause!
    begin
      TripAssignment.transaction do
        # Pessimistic Locking in order to prevent race-conditions
        trip.lock!

        if pausable? # WARNING! This method define the instance var @open_assignments. TO-DO: Improve this
          now = Time.current

          @open_assignments.each do |assignment|
            assignment.update!(closed_at: now)
          end

          trip.update!(status: nil)
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
    return true if trip_still_waiting? && trip.trip_assignments.opened.blank?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_assign_trip')) && false
  end

  def broadcastable?
    return true if trip_still_waiting? && trip.trip_assignments.opened.blank?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_broadcast_trip')) && false
  end

  def trip_still_waiting?
    trip.status.blank? || trip.status == 'waiting_shipper'
  end

  def takable?
    return true if trip.status == 'waiting_shipper' && valid_open_assignments?

    errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_take_trip')) && false
  end

  def pausable?
    return true if trip.status == 'waiting_shipper' && valid_open_assignments?

    # errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.cannot_pause_trip')) && false
  end

  def valid_open_assignments?
    # TO-DO: We should improve this, in order to handle the shipper information if it's an assigned trip for instance.
    @open_assignments = trip.trip_assignments.opened.where(state: ['assigned', 'broadcasted'])

    return true if @open_assignments.present? || @open_assignments.empty?

    # errors.add(:trip_dispatch, I18n.t('services.trip_dispatcher.no_valid_open_assignments')) && false
  end

end
