module Api
  module V1
    class MembershipsController < BaseController
      def index
        render json: organization.memberships
      end

      def show
        render json: organization.memberships.find(params[:id])
      end

      def create
        membership = organization.memberships.new
        membership.user_id = membership_user_id
        membership.role = membership_role
        membership.save!
        render json: membership, status: :created
      end

      def update
        membership = organization.memberships.find(params[:id])
        membership.role = membership_role
        membership.save!
        render json: membership
      end

      def destroy
        membership = organization.memberships.find(params[:id])
        membership.destroy
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
