class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_default_params

  # after_filter :store_location

  before_filter :add_www_subdomain if Rails.env.production?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :summoner_name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :summoner_name, :phone) }
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url]
  end


  def set_default_params
    @currently_in_competitions = []
    if current_user != nil
        @currently_in_competitions = PlayersInCompetitions.where(:user_id => current_user.id).order("id DESC")
    end
  end

  helper_method :resource_name
  helper_method :resource
  helper_method :devise_mapping
  helper_method :current_controller?
  helper_method :current_more?

  def current_more?
    if params["action"] == "about" or params["action"] == "help"
      return "active"
    else
      return ""
    end
  end


  def current_controller?(controller)
    if params["controller"] == controller
      return "active"
    else
      return ""
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private
  def add_www_subdomain

    unless /^www/.match(request.host)
      redirect_to("#{request.protocol}www.#{request.host_with_port}#{request.fullpath}",
                  :status => 200)
    end
  end


end
