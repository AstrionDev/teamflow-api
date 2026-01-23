class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :projects, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :audit_logs, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates :name, presence: true

  after_create_commit :ensure_subscription!

  private

  def ensure_subscription!
    return if subscription

    create_subscription!(plan_name: "free", status: "active")
  end
end
