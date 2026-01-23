module Api
  module V1
    class SubscriptionsController < BaseController
      def show
        subscription = ensure_subscription!
        authorize subscription
        render json: subscription
      end

      def update
        subscription = ensure_subscription!
        authorize subscription
        subscription.update!(subscription_params)
        log_audit!(action: "subscription.updated", record: subscription, organization: organization)
        render json: subscription
      end

      private

      def organization
        Organization.find(params[:organization_id])
      end

      def ensure_subscription!
        organization.subscription || organization.create_subscription!(plan_name: "free", status: "active")
      end

      def subscription_params
        params.require(:subscription).permit(:plan_name, :status, :current_period_ends_at, limits: {})
      end
    end
  end
end
