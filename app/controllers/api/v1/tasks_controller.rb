module Api
  module V1
    class TasksController < BaseController
      def index
        tasks = policy_scope(project.tasks)
        render json: tasks
      end

      def show
        task = project.tasks.find(params[:id])
        authorize task
        render json: task
      end

      def create
        task = project.tasks.new(task_params)
        authorize task
        task.save!
        render json: task, status: :created
      end

      def update
        task = project.tasks.find(params[:id])
        authorize task
        task.update!(task_params)
        render json: task
      end

      def destroy
        task = project.tasks.find(params[:id])
        authorize task
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
