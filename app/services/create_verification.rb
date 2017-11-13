class CreateVerification
  prepend Service::Base

  def initialize(verificable, allowed_params, current_user)
    @verificable = verificable
    @allowed_params = allowed_params
    @current_user = current_user
  end

  def call
    create_verification
  end

  private

  def create_verification
    @verification = @verificable.verifications.new( verification_params )

    return if errors.any?

    return @verification if @verification.save

    errors.add_multiple_errors(@verification.errors.messages) && nil
  end

  def verification_params
    {
      data: verification_data
    }.tap do |_params|
      if boolean(@allowed_params[:verified])
        _params[:verified_at] = Time.now
        _params[:verified_by] = @current_user.id
      end
      if expire = boolean(@allowed_params[:expire])
        _params[:expire_at] = @allowed_params[:expire_at]
      end
      _params[:expire] = expire
    end
  end

  def verification_data
    if allowed_types.include?(@allowed_params[:type])
      {
        type: @allowed_params[:type],
        information: allowed_information
      }
    else
      errors.add(:type, I18n.t('services.create_verification.type.missing_or_invalid', class_name: @verificable.class.name, allowed_types: allowed_types.join(', '))) && nil
    end
  end

  def allowed_types
    @allowed_types ||= @verificable.class::VERIFICATIONS.keys.map(&:to_s)
  end

  def allowed_information
    allowed_keys = @verificable.class::VERIFICATIONS[@allowed_params[:type]]

    information = (@allowed_params[:information] || {}).keep_if{|key, _| allowed_keys.include?(key) }

    if information.present?
      information
    else
      errors.add(:information, I18n.t('services.create_verification.information.missing_or_invalid', type_name: @allowed_params[:type], allowed_keys: allowed_keys.join(', '))) && nil
    end
  end

end
