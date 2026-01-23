module Api
  module V1
    class InvitationsController < BaseController
      def index
        invitations = policy_scope(organization.invitations)
        render json: invitations
      end

      def show
        invitation = organization.invitations.find(params[:id])
        authorize invitation
        render json: invitation
      end

      def create
        invitation = organization.invitations.new(invitation_params.merge(invited_by: current_user))
        invitation.role = invitation_role
        authorize invitation
        PlanLimit.enforce!(
          organization.subscription,
          :pending_invitations,
          organization.invitations.pending.count
        )
        invitation.save!
        log_audit!(action: "invitation.created", record: invitation, organization: organization)
        render json: invitation, status: :created
      end

      def destroy
        invitation = organization.invitations.find(params[:id])
        authorize invitation
        invitation.update!(status: "canceled")
        log_audit!(action: "invitation.canceled", record: invitation, organization: organization)
        head :no_content
      end

      private

      def organization
        Organization.find(params[:organization_id])
      end

      def invitation_params
        params.require(:invitation).permit(:email, :expires_at)
      end

      def invitation_role
        role = params.require(:invitation).require(:role)
        unless Membership::ROLES.include?(role)
          raise ActionController::BadRequest, "invalid role"
        end
        role
      end
    end
  end
end
