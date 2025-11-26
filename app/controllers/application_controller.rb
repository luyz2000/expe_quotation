class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Method

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name, :username, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :last_name, :username, :email, :password, :current_password])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :remember_me])
  end
end
