module Api
  module V1
    class OrganizationsController < BaseController
      def index
        render json: Organization.all
      end

      def show
        render json: Organization.find(params[:id])
      end

      def create
        organization = Organization.create!(organization_params)
        render json: organization, status: :created
      end

      def update
        organization = Organization.find(params[:id])
        organization.update!(organization_params)
        render json: organization
      end

      def destroy
        organization = Organization.find(params[:id])
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
