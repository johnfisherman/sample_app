class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
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
    # submitting the form results in a user hash with attributes 
    # corresponding to the submitted values, where the keys come 
    # from the name attributes of the input tags (HTML side)
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      # we can omit the user_path in the redirect, writing simply redirect_to @user to redirect to the user show page
      flash[:success] = "User created successfully! You are now one of us!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # correct_user comes to make this redundant, as it is always called before edit and update
    # @user = User.find(params[:id])
  end
  
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      # we sign in the user as part of a successful profile update; this is because the remember token gets reset when the user is saved,
      # which invalidates the user’s session. 
      # This is a nice security feature, as it means that any hijacked sessions will automatically expire when the user information is changed.
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "The User is no more..."
    redirect_to users_path
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."  
    end
    
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
end
