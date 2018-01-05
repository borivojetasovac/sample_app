module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id     # This temporary cookies created using session method are automatically encrypted.
  end

  # Returns the current Logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])   # Memoization - stor the result of expensive function call, and return local result when the same input occur again
  end

  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
