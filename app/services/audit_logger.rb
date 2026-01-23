class AuditLogger
  def self.log!(actor:, organization:, action:, auditable: nil, metadata: nil, request: nil)
    AuditLog.create!(
      organization: organization,
      actor: actor,
      action: action,
      auditable: auditable,
      metadata: metadata,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent
    )
  end
end
