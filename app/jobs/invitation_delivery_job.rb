class InvitationDeliveryJob < ApplicationJob
  queue_as :default

  def perform(invitation_id)
    invitation = Invitation.find_by(id: invitation_id)
    return unless invitation
    return unless invitation.status == "pending"

    invitation.update!(status: "sent", sent_at: Time.current)
  end
end
