module Api
  module V1
    class OrganizationsController < BaseController
      def index
        organizations = policy_scope(Organization)
        render json: organizations
      end

      def show
        organization = Organization.find(params[:id])
        authorize organization
        render json: organization
      end

      def create
        organization = Organization.new(organization_params)
        authorize organization

        Organization.transaction do
          organization.save!
          organization.memberships.create!(user: current_user, role: "owner")
        end

        render json: organization, status: :created
      end

      def update
        organization = Organization.find(params[:id])
        authorize organization
        organization.update!(organization_params)
        render json: organization
      end

      def destroy
        organization = Organization.find(params[:id])
        authorize organization
        organization.destroy
        head :no_content
      end

      private

      def organization_params
        params.require(:organization).permit(:name)
      end
    end
  end
end
