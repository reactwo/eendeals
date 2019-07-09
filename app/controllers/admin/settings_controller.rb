class Admin::SettingsController < ApplicationController

  layout 'admin'

  def index
    @settings = Setting.all.order(id: :desc)
  end

  def update
    params[:settings][:array].each do |setting|
      val = Setting.find setting[:key]
      val.update(value: setting[:value])
    end
    flash[:success] = 'Settings updated'
    redirect_to admin_settings_path
  end

end
