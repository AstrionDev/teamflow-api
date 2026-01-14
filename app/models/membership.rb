class Membership < ApplicationRecord
  ROLES = %w[ owner admin member ].freeze

  belongs_to :user
  belongs_to :organization

  validates :role, presence: true, inclusion: { in: ROLES }
end
