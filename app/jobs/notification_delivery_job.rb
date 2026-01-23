class NotificationDeliveryJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find_by(id: notification_id)
    return unless notification
    return if notification.delivered_at.present?

    notification.update!(status: "delivered", delivered_at: Time.current)
  end
end
