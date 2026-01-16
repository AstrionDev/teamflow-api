module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_user!, only: :login
      skip_after_action :verify_authorized, only: :login

      def login
        user = User.find_by!(email: params.require(:email))
        unless user.authenticate(params.require(:password))
          return render json: { error: "invalid_credentials" }, status: :unauthorized
        end

        token = JsonWebToken.encode({ "sub" => user.id })
        render json: { token: token }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "invalid_credentials" }, status: :unauthorized
      end
    end
  end
end
