class UpdateUser
  prepend Service::Base
  include Service::Support::User

  def initialize(user, allowed_params)
    @user = user
    @allowed_params = allowed_params
  end

  def call
    update_user
  end

  private

  def update_user
    @user.assign_attributes( user_params )

    if @user.save
      @user.profile.update( profile_params )

      return @user
    end

    errors.add_multiple_errors(@user.errors.messages) && nil
  end

end
