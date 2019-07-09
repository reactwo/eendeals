class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, if: lambda { |controller|
    (controller.class.name === 'PagesController' && (controller.action_name === 'privacy' || controller.action_name === 'terms') ) ? false : true
  }
  before_action :check_admin!, if: lambda { |controller|
    (controller.class.name === 'PagesController' && (controller.action_name === 'privacy' || controller.action_name === 'terms') ) ? false : true
  }

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      'admin'
    else
      'application'
    end
  end

  def after_sign_in_path_for(resource)
    if resource.has_role? :admin
      admin_path
    else
      sign_out resource
      redirect_to root_path
    end
  end

  def check_admin!
    if current_user
      unless current_user.has_role? :admin
        sign_out current_user
        redirect_to root_path
      end
    else
      unless devise_controller?
        redirect_to new_user_session_path
      end
    end
  end
end
