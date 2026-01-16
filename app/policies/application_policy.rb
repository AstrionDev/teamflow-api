class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def member_of?(organization)
    return false unless user
    organization.memberships.exists?(user_id: user.id)
  end

  def role_for(organization)
    return nil unless user
    organization.memberships.find_by(user_id: user.id)&.role
  end

  def owner_or_admin?(organization)
    %w[owner admin].include?(role_for(organization))
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.none
    end
  end
end
