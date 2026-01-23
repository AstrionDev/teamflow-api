class Notification < ApplicationRecord
  STATUSES = %w[ pending delivered failed ].freeze

  belongs_to :organization
  belongs_to :user

  validates :kind, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  after_commit :enqueue_delivery, on: :create

  private

  def enqueue_delivery
    NotificationDeliveryJob.perform_later(id)
  end
end
