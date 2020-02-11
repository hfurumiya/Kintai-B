class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update,:destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:show, :edit, :update, :index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
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
      flash[:success] = 'やったね！成功!!'
      redirect_to @user
    else
      flash.now[:warning] = 'あかん、下記のエラー見て直して'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render :edit      
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
      redirect_to users_url
  end

  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :department)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to(root_url) 
      end
    end
    
    def admin_user
      unless current_user.admin?
        redirect_to root_url 
      end
    end
end
