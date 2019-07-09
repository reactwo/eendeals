class Admin::NotificationsController < ApplicationController

  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: NotificationDatatable.new(view_context) }
    end
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new notifications_params
    if @notification.save
      User.where('token IS NOT NULL').in_batches(of: 100) do |users|
        Notification.delay.send_notifications @notification.message, users.pluck(:token)
      end
      flash[:success] = 'Notification created'
      redirect_to admin_notifications_path
    else
      render 'new'
    end
  end

  def destroy
    @notification = Notification.find_by_id params[:id]
    if @notification.destroy
      flash[:success] = 'Notification deleted'
    else
      flash[:error] = 'Notification cannot be deleted'
    end
    redirect_to admin_notifications_path
  end

  private

  def notifications_params
    params.require(:notification).permit(:message)
  end

end