class Invitation < ApplicationRecord
  STATUSES = %w[ pending sent accepted expired canceled ].freeze

  belongs_to :organization
  belongs_to :invited_by, class_name: "User", optional: true

  validates :email, presence: true
  validates :role, presence: true, inclusion: { in: Membership::ROLES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :token, presence: true, uniqueness: true

  before_validation :set_defaults, on: :create
  after_commit :enqueue_delivery, on: :create

  scope :pending, -> { where(status: "pending") }

  private

  def set_defaults
    self.token ||= SecureRandom.hex(16)
  end

  def enqueue_delivery
    InvitationDeliveryJob.perform_later(id)
  end
end
