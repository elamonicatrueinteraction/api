class CreateUser
  prepend Service::Base
  include Service::Support::User

  def initialize(institution, allowed_params)
    @institution = institution
    @allowed_params = allowed_params
  end

  def call
    create_user
  end

  private

  def create_user
    @user = @institution.users.new( user_params )
    @user.profile = Profile.new( profile_params )

    return @user if @user.save

    errors.add_multiple_errors(@user.errors.messages) && nil
  end

end
