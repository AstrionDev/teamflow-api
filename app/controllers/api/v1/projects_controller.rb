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
        PlanLimit.enforce!(organization.subscription, :projects, organization.projects.count)
        project.save!
        log_audit!(action: "project.created", record: project, organization: organization)
        render json: project, status: :created
      end

      def update
        project = organization.projects.find(params[:id])
        authorize project
        project.update!(project_params)
        log_audit!(action: "project.updated", record: project, organization: organization)
        render json: project
      end

      def destroy
        project = organization.projects.find(params[:id])
        authorize project
        project.destroy
        log_audit!(action: "project.deleted", record: project, organization: organization)
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
