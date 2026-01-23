module Api
  module V1
    class MembershipsController < BaseController
      def index
        memberships = policy_scope(organization.memberships)
        render json: memberships
      end

      def show
        membership = organization.memberships.find(params[:id])
        authorize membership
        render json: membership
      end

      def create
        membership = organization.memberships.new(user_id: membership_user_id, role: membership_role)
        authorize membership
        PlanLimit.enforce!(organization.subscription, :memberships, organization.memberships.count)
        membership.save!
        log_audit!(action: "membership.created", record: membership, organization: organization)
        render json: membership, status: :created
      end

      def update
        membership = organization.memberships.find(params[:id])
        authorize membership
        membership.role = membership_role
        membership.save!
        log_audit!(action: "membership.updated", record: membership, organization: organization)
        render json: membership
      end

      def destroy
        membership = organization.memberships.find(params[:id])
        authorize membership
        membership.destroy
        log_audit!(action: "membership.deleted", record: membership, organization: organization)
        head :no_content
      end

      private

      def organization
        Organization.find(params[:organization_id])
      end

      def membership_role
        params.require(:membership).require(:role)
      end

      def membership_user_id
        params.require(:membership).require(:user_id)
      end
    end
  end
end
