module Api
  module V1
    class ProjectsController < BaseController
      def index
        projects = policy_scope(organization.projects)
        render json: projects
      end

      def show
        project = organization.projects.find(params[:id])
        authorize project
        render json: project
      end

      def create
        project = organization.projects.new(project_params)
        authorize project
        project.save!
        render json: project, status: :created
      end

      def update
        project = organization.projects.find(params[:id])
        authorize project
        project.update!(project_params)
        render json: project
      end

      def destroy
        project = organization.projects.find(params[:id])
        authorize project
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
