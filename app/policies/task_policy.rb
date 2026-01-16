class TaskPolicy < ApplicationPolicy
  def show?
    member_of?(record.project.organization)
  end

  def create?
    member_of?(record.project.organization)
  end

  def update?
    member_of?(record.project.organization)
  end

  def destroy?
    owner_or_admin?(record.project.organization)
  end

  class Scope < Scope
    def resolve
      return scope.none unless user
      scope.joins(:project).where(projects: { organization_id: user.memberships.select(:organization_id) })
    end
  end
end
