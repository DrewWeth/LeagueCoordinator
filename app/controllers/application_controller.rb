class ApplicationController < ActionController::Base

  RED = "16711680"
  DIV = "3335782"
  GREEN = "008000"

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_default_params

  after_filter :store_location

  # before_filter :add_www_subdomain if Rails.env.production?

  helper_method :get_color


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :summoner_name, :phone, :f_name, :l_name) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :summoner_name, :phone, :name, :f_name, :l_name) }
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
    session[:previous_url] || root_path
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


  def get_color( n )
    return GREEN.prepend("#") if n > 5
    return RED.to_i.to_s(16).prepend("#") if n < 2
    color = (RED.to_i - ( DIV.to_i * ( n - 1 ) ) ).to_i.to_s(16)
    check_length(color)
  end

  def check_length(color)
    diff = 6 - color.length
    if diff > 0
      color.prepend("0" * diff)
    end
    color.prepend("#")
  end



end
