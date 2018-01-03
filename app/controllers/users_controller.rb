class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,    # strong parameters: specify which parameters are required and which are permitted
                                    :password_confirmation)     # the code returns a version of the params hash with only the permitted (and required - or error) attributes
    end
end
