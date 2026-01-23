module Api
  module V1
    class NotificationsController < BaseController
      def index
        notifications = policy_scope(Notification)
        render json: notifications
      end

      def show
        notification = Notification.find(params[:id])
        authorize notification
        render json: notification
      end

      def update
        notification = Notification.find(params[:id])
        authorize notification

        if params[:notification]&.key?(:read)
          read_value = ActiveModel::Type::Boolean.new.cast(params[:notification][:read])
          notification.read_at = read_value ? Time.current : nil
        end

        notification.save!
        render json: notification
      end
    end
  end
end
