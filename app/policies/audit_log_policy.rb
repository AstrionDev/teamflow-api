class AuditLogPolicy < ApplicationPolicy
  def index?
    owner_or_admin?(record.organization)
  end

  def show?
    owner_or_admin?(record.organization)
  end

  class Scope < Scope
    def resolve
      return scope.none unless user
      scope.where(organization_id: user.memberships.where(role: %w[ owner admin ]).select(:organization_id))
    end
  end
end
