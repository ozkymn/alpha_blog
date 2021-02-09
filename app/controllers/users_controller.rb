class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:show, :index, :edit, :update]
  before_action :require_same_user, only:[:show, :index, :edit, :update, :destroy]

  def show
    @article = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Succesfully Update"
      redirect_to @user
    else
      render 'edit'
    end    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You Sign-Up #{@user.username}"
      redirect_to root_path
    else
      render 'new'
    end  
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user 
    flash[:notice] = "Account and all deleted"
    redirect_to root_path
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
    
    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:alert] = "You cant do"
        redirect_to @user
      end
    end      

end
