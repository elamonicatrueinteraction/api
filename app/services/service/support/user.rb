module Service
  module Support
    module User

      private

      def user_params
        @user_params ||= @allowed_params.select do |key, _|
          %w[username email password active].include?(key.to_s)
        end
      end

      def profile_params
        @profile_params ||= @allowed_params.select do |key, _|
          %w[first_name last_name cellphone].include?(key.to_s)
        end
      end

    end
  end
end
