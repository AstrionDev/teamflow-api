module Api
  module V1
    class TasksController < BaseController
      SORTABLE_FIELDS = %w[ title status priority due_date created_at updated_at ].freeze

      def index
        tasks = policy_scope(project.tasks)
        tasks = apply_filters(tasks)
        total_count = tasks.count
        tasks = apply_sorting(tasks)
        tasks = apply_pagination(tasks)
        set_pagination_headers(total_count)
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
        PlanLimit.enforce!(project.organization.subscription, :tasks_per_project, project.tasks.count)
        task.save!
        log_audit!(action: "task.created", record: task, organization: organization)
        render json: task, status: :created
      end

      def update
        task = project.tasks.find(params[:id])
        authorize task
        task.update!(task_params)
        log_audit!(action: "task.updated", record: task, organization: organization)
        render json: task
      end

      def destroy
        task = project.tasks.find(params[:id])
        authorize task
        task.destroy
        log_audit!(action: "task.deleted", record: task, organization: organization)
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

      def apply_filters(scope)
        if params[:status].present?
          unless Task::STATUSES.include?(params[:status])
            raise ActionController::BadRequest, "invalid status filter"
          end
          scope = scope.where(status: params[:status])
        end

        if params[:assignee_id].present?
          assignee_id = Integer(params[:assignee_id], 10)
          scope = scope.where(assignee_id: assignee_id)
        end

        if params[:priority].present?
          priority = Integer(params[:priority], 10)
          unless Task::PRIORITY_RANGE.cover?(priority)
            raise ActionController::BadRequest, "invalid priority filter"
          end
          scope = scope.where(priority: priority)
        end

        if params[:due_before].present?
          due_before = parse_date_param(params[:due_before], "due_before")
          scope = scope.where("tasks.due_date <= ?", due_before)
        end

        if params[:due_after].present?
          due_after = parse_date_param(params[:due_after], "due_after")
          scope = scope.where("tasks.due_date >= ?", due_after)
        end

        if params[:search].present?
          query = ActiveRecord::Base.sanitize_sql_like(params[:search].downcase)
          scope = scope.where("LOWER(tasks.title) LIKE ?", "%#{query}%")
        end

        scope
      rescue ArgumentError
        raise ActionController::BadRequest, "invalid filter value"
      end

      def apply_sorting(scope)
        sort_param = params[:sort].to_s
        return scope.order(created_at: :desc) if sort_param.blank?

        orderings = {}
        sort_param.split(",").each do |token|
          direction = token.start_with?("-") ? :desc : :asc
          field = token.delete_prefix("-")
          unless SORTABLE_FIELDS.include?(field)
            raise ActionController::BadRequest, "invalid sort field #{field}"
          end
          orderings[field.to_sym] = direction
        end

        scope.order(orderings)
      end

      def apply_pagination(scope)
        page = params.fetch(:page, 1).to_i
        page = 1 if page < 1
        per_page = params.fetch(:per_page, 25).to_i
        per_page = 25 if per_page < 1
        per_page = 100 if per_page > 100

        @pagination_page = page
        @pagination_per_page = per_page

        scope.offset((page - 1) * per_page).limit(per_page)
      end

      def set_pagination_headers(total_count)
        per_page = @pagination_per_page || 25
        page = @pagination_page || 1
        total_pages = (total_count.to_f / per_page).ceil

        response.set_header("X-Total-Count", total_count.to_s)
        response.set_header("X-Total-Pages", total_pages.to_s)
        response.set_header("X-Page", page.to_s)
        response.set_header("X-Per-Page", per_page.to_s)
      end

      def parse_date_param(value, name)
        Date.iso8601(value)
      rescue ArgumentError
        raise ActionController::BadRequest, "invalid #{name} date"
      end
    end
  end
end
