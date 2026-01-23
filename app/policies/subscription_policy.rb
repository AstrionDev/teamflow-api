class SubscriptionPolicy < ApplicationPolicy
  def show?
    owner_or_admin?(record.organization)
  end

  def update?
    owner_or_admin?(record.organization)
  end
end
