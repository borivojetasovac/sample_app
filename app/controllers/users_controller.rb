class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # Before filter: arrange for a particulalr method(logged_in_user) to be called before given actions
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])    # Only display users if they are activated.
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_path and return unless @user.activated?              # Redirect to root if the user is not activated.
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,    # strong parameters: specify which parameters are required and which are permitted
                            :password_confirmation, :admin)     # the code returns a version of the params hash with only the permitted (and required - or error) attributes
    end

    # Before filters      (by default, they apply to every action in controller, so we restrict them by passing only: options hash)

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
