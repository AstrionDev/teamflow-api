class Task < ApplicationRecord
  STATUSES = %w[todo in_progress done].freeze

  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: 0..2 }
end
