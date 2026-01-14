module Api
  module V1
    class BaseController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActiveRecord::InvalidForeignKey, with: :render_conflict

      private

      def render_not_found
        render json: { error: "not_found" }, status: :not_found
      end

      def render_unprocessable_entity(error)
        render json: { error: "validation_failed", details: error.record.errors }, status: :unprocessable_entity
      end

      def render_conflict
        render json: { error: "conflict" }, status: :conflict
      end
    end
  end
end
