class Api::BaseController < ActionController::API
  before_action :check_version, if: lambda { |controller|
     (controller.class.name === 'Api::V1::TrackingController') ||
         (controller.class.name === 'Api::V1::SettingsController' && controller.action_name === 'game') ? false : true
  }
  acts_as_token_authentication_handler_for User, fallback: :exception, if: lambda { |controller|
          ((controller.class.name === 'Api::V1::UsersController' && %w(create authorize sponsor_ids).include?(controller.action_name)) ||
           (controller.class.name === 'Api::V1::TrackingController')) ||
              (controller.class.name === 'Api::V1::SettingsController' && controller.action_name === 'game') ? false : true
        }

  protected

  def check_version
    unless request.headers['X-App-Version'].nil?
      if request.headers['X-App-Version'].to_f < Setting.app_version.to_f
        render json: {errors: {
                 application: ["needs to be updated"],
               }}
      end
    else
      render json: {errors: {
               application: ["needs to be updated"],
             }} and return
    end
  end

  def get_limit
    today = Date.today
    limit = current_user.limits.where('created_at > ?', today).last
    if limit
      limit
    else
      Limit.create(video1: 0, video2: 0, user: current_user)
    end
  end
end
