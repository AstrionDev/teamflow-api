module Api
  module V1
    class BaseController < ActionController::API
      include Pundit::Authorization

      before_action :authenticate_user!
      after_action :verify_authorized, if: :verify_pundit_authorization?
      after_action :verify_policy_scoped, if: :verify_pundit_policy_scope?

      rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActiveRecord::InvalidForeignKey, with: :render_conflict
      rescue_from ActionController::ParameterMissing, with: :render_bad_request

      private

      def render_forbidden
        render json: { error: "forbidden" }, status: :forbidden
      end

      def render_not_found
        render json: { error: "not_found" }, status: :not_found
      end

      def render_unprocessable_entity(error)
        render json: { error: "validation_failed", details: error.record.errors }, status: :unprocessable_entity
      end

      def render_conflict
        render json: { error: "conflict" }, status: :conflict
      end

      def render_bad_request(error)
        render json: { error: "bad_request", details: error.message }, status: :bad_request
      end

      def authenticate_user!
        header = request.headers["Authorization"].to_s
        token = header.split(" ").last
        return render json: { error: "unauthorized" }, status: :unauthorized if token.blank?

        payload = JsonWebToken.decode(token)
        @current_user = User.find(payload["sub"])
      rescue JsonWebToken::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "unauthorized" }, status: :unauthorized
      end

      def current_user
        @current_user
      end

      def pundit_user
        @current_user
      end

      def verify_pundit_authorization?
        pundit_user && action_name != "index"
      end

      def verify_pundit_policy_scope?
        pundit_user && action_name == "index"
      end
    end
  end
end
