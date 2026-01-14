class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :assigned_tasks,
           class_name: "Task",
           foreign_key: :assignee_id,
           inverse_of: :assignee,
           dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
