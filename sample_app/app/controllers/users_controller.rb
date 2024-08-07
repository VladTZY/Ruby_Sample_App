class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @pagy_microposts, @microposts = pagy(@user.microposts)

    redirect_to root_url and return unless @user.activated?
  end
  
  def index
    @pagy, @users = pagy(User.where(activated: true))
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new', status: 500
    end
  end

  def edit
    # setting the @user already done in correct_user before action
  end

  def update
    # setting the @user already done in correct_user before actio

    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: 500
    end
  end

  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @pagy_follow, @users = pagy(@user.following)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @pagy_follow, @users = pagy(@user.followers)
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
