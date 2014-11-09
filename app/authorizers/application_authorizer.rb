# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    false
  end

  after_filter :store_location

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

end
