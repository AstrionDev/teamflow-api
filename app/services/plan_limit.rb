module PlanLimit
  class LimitExceeded < StandardError
    attr_reader :limit_key, :limit, :current

    def initialize(limit_key, limit:, current:)
      @limit_key = limit_key.to_s
      @limit = limit
      @current = current
      super("plan limit exceeded for #{limit_key}")
    end
  end

  PLAN_LIMITS = {
    "free" => {
      "projects" => 3,
      "tasks_per_project" => 100,
      "memberships" => 5,
      "pending_invitations" => 5
    },
    "pro" => {
      "projects" => 20,
      "tasks_per_project" => 1_000,
      "memberships" => 50,
      "pending_invitations" => 100
    },
    "enterprise" => {
      "projects" => nil,
      "tasks_per_project" => nil,
      "memberships" => nil,
      "pending_invitations" => nil
    }
  }.freeze

  def self.limit_for(subscription, key)
    key = key.to_s
    custom_limits = subscription&.limits || {}
    return custom_limits[key] if custom_limits.key?(key)

    plan = subscription&.plan_name || "free"
    PLAN_LIMITS.dig(plan, key)
  end

  def self.enforce!(subscription, key, current)
    limit = limit_for(subscription, key)
    return if limit.nil?
    return if current < limit

    raise LimitExceeded.new(key, limit: limit, current: current)
  end
end
