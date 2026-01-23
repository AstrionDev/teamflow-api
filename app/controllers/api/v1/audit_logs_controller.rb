module Api
  module V1
    class AuditLogsController < BaseController
      def index
        audit_logs = policy_scope(organization.audit_logs).order(created_at: :desc)
        render json: audit_logs
      end

      private

      def organization
        Organization.find(params[:organization_id])
      end
    end
  end
end
