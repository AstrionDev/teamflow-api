class Subscription < ApplicationRecord
  PLANS = %w[ free pro enterprise ].freeze
  STATUSES = %w[ active trialing canceled past_due ].freeze

  belongs_to :organization

  validates :plan_name, presence: true, inclusion: { in: PLANS }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :limits_format

  def limit_for(key)
    PlanLimit.limit_for(self, key)
  end

  private

  def limits_format
    return if limits.blank? || limits.is_a?(Hash)

    errors.add(:limits, "must be a JSON object")
  end
end
