class MembershipPolicy < ApplicationPolicy
  def show?
    member_of?(record.organization)
  end

  def create?
    owner_or_admin?(record.organization)
  end

  def update?
    owner_or_admin?(record.organization)
  end

  def destroy?
    owner_or_admin?(record.organization)
  end

  class Scope < Scope
    def resolve
      return scope.none unless user
      scope.where(organization_id: user.memberships.select(:organization_id))
    end
  end
end
