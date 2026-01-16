class UserPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present? && record.id == user.id
  end

  def create?
    true
  end

  def update?
    user.present? && record.id == user.id
  end

  def destroy?
    user.present? && record.id == user.id
  end

  class Scope < Scope
    def resolve
      return scope.none unless user
      scope.where(id: user.id)
    end
  end
end
