class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :check_version

  respond_to :json

  def create
    build_resource(sign_up_params)

    if params[:user] and params[:user][:gender]
      if params[:user][:gender].downcase === 'male'
        resource.gender = User::GENDER[:male]
      elsif params[:user][:gender].downcase === 'female'
        resource.gender = User::GENDER[:female]
      end
    end

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :mobile, :gender])
  end

  def check_version
    if request.headers['X-App-Version'].to_f < 1
      render json: { status: false, error: 'Update application' }
    end
  end

end