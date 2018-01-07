class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]   # Before filter: arrange for a particulalr method(logged_in_user) to be called before given actions
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"    # the Rails way to display a temporary message (:success key for a message indicating a successful result)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,    # strong parameters: specify which parameters are required and which are permitted
                                    :password_confirmation)     # the code returns a version of the params hash with only the permitted (and required - or error) attributes
    end

    # Before filters      (by default, they apply to every action in controller, so we restrict them by passing only: options hash)

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
