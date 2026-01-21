class Task < ApplicationRecord
  STATUSES = %w[ todo in_progress done ].freeze
  STATUS_TRANSITIONS = {
    "todo" => [ "in_progress" ],
    "in_progress" => [ "done" ],
    "done" => []
  }.freeze
  PRIORITY_RANGE = (0..2).freeze

  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITY_RANGE }
  validate :status_transition, if: :will_save_change_to_status?

  def can_transition_to?(next_status)
    return false if next_status.blank?
    return true if status.blank?

    STATUS_TRANSITIONS.fetch(status, []).include?(next_status)
  end

  private

  def status_transition
    return if new_record?

    previous_status = status_was
    return if previous_status.nil?

    unless STATUS_TRANSITIONS.fetch(previous_status, []).include?(status)
      errors.add(:status, "cannot transition from #{previous_status} to #{status}")
    end
  end
end
