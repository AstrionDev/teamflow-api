class NotificationPolicy < ApplicationPolicy
  def show?
    user && record.user_id == user.id
  end

  def update?
    show?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user
      scope.where(user_id: user.id)
    end
  end
end
