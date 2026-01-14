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
        membership = organization.memberships.create!(membership_params)
        render json: membership, status: :created
      end

      def update
        membership = organization.memberships.find(params[:id])
        membership.update!(membership_params)
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

      def membership_params
        params.require(:membership).permit(:user_id, :role)
      end
    end
  end
end
