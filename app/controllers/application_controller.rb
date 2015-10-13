class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Store session for redirect param 
  # See https://stackoverflow.com/questions/8559088/rails-devise-pass-url-to-login
  before_filter :store_location

  def store_location
    session[:redirect] = params[:redirect] if params[:redirect]
  end

  # Add extra parameters to the basic Devise user registration
  # See https://github.com/plataformatec/devise#strong-parameters
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Handle unauthorized access to the admin interface
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  # After successful login, go to admin page
  def after_sign_in_path_for(resource)
    if session[:redirect]
      session[:redirect]  # Is exist session redirect we use it to redirect
    elsif current_user.admin?
      rails_admin.dashboard_path  # Redirect admin users to admin dashboard
    else
      root_path # We check if we login from photomaton voting in order to redirect to the original photomaton url
    end
  end

  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    # Force Admin locale to English
    I18n.locale = :en if is_a?(RailsAdmin::ApplicationController)
  end
end
