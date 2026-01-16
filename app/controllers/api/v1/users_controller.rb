module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate_user!, only: :create

      def index
        users = policy_scope(User)
        render json: users
      end

      def show
        user = User.find(params[:id])
        authorize user
        render json: user
      end

      def create
        user = User.new(user_params)
        authorize user
        user.save!
        render json: user, status: :created
      end

      def update
        user = User.find(params[:id])
        authorize user
        user.update!(user_params)
        render json: user
      end

      def destroy
        user = User.find(params[:id])
        authorize user
        user.destroy
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
