class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @article = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])  
  end

  def update
    @user = User.find(params[:id])
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
      flash[:notice] = "You Sign-Up #{@user.username}"
      redirect_to articles_path
    else
      render 'new'
    end  
  end
  private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

end
