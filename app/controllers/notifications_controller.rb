class NotificationsController < ApplicationController
  before_action :require_authentication

  def index
    @notifications = current_user.notifications.recent.limit(50)
  end

  def read
    notification = current_user.notifications.find(params[:id])
    notification.mark_read!
    redirect_to notification.link_path.presence || notifications_path
  end

  def read_all
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: "All notifications marked read."
  end
end
