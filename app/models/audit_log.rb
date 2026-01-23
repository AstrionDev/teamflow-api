class AuditLog < ApplicationRecord
  belongs_to :organization
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :auditable, polymorphic: true, optional: true

  validates :action, presence: true
end
