class OrganizationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    member_of?(record)
  end

  def create?
    user.present?
  end

  def update?
    owner_or_admin?(record)
  end

  def destroy?
    owner_or_admin?(record)
  end

  class Scope < Scope
    def resolve
      return scope.none unless user
      scope.joins(:memberships).where(memberships: { user_id: user.id }).distinct
    end
  end
end
