class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user     # Remember logged-in user automatically.
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'   # flash.now disappear as soon as there is an additional request
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?     # Log out only if user is logged-in (case with multiple tabs open).
    redirect_to root_url
  end
end
