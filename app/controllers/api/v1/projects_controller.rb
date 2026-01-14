module Api
  module V1
    class ProjectsController < BaseController
      def index
        render json: organization.projects
      end

      def show
        render json: organization.projects.find(params[:id])
      end

      def create
        project = organization.projects.create!(project_params)
        render json: project, status: :created
      end

      def update
        project = organization.projects.find(params[:id])
        project.update!(project_params)
        render json: project
      end

      def destroy
        project = organization.projects.find(params[:id])
        project.destroy
        head :no_content
      end

      private

      def organization
        Organization.find(params[:organization_id])
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
