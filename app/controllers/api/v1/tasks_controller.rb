module Api
  module V1
    class TasksController < BaseController
      def index
        render json: project.tasks
      end

      def show
        render json: project.tasks.find(params[:id])
      end

      def create
        task = project.tasks.create!(task_params)
        render json: task, status: :created
      end

      def update
        task = project.tasks.find(params[:id])
        task.update!(task_params)
        render json: task
      end

      def destroy
        task = project.tasks.find(params[:id])
        task.destroy
        head :no_content
      end

      private

      def organization
        Organization.find(params[:organization_id])
      end

      def project
        organization.projects.find(params[:project_id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :priority, :due_date, :assignee_id)
      end
    end
  end
end
