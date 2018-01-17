module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id     # This temporary cookies created using session method are automatically encrypted.
  end

  # Remember a user in a persistent session.
  def remember(user)
    user.remember     # Creates a new token in user.remember_token, and saves token digest (remember_digest) in the database.
    cookies.permanent.signed[:user_id] = user.id     # signed encrypts the cookie before placing it on the browser.
    cookies.permanent[:remember_token] = user.remember_token    # Places encrypted user_id and remember_token to the browser.
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the user coresponding to the remember token cookie.
  def current_user      # Memoization - store the result of expensive function call, and return local result when the same input occur again
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored Location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?    # request.original_url - to get the URL of the requested page
  end                                                                   # request.get - only for a GET request (prevent some edge case)
end
