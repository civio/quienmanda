class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Add extra parameters to the basic Devise user registration
  # See https://github.com/plataformatec/devise#strong-parameters
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Handle unauthorized access to the admin interface
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  before_action :set_locale

  before_action :set_caching_headers

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

  # Mark responses to requests as cacheable for an hour
  def set_caching_headers
    if current_user.nil?
      expires_in(3600.seconds, public: true)  # Cache anywhere, including our rack-cache
    end
  end
end
