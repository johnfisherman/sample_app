class UsersController < ApplicationController
  
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
      # we can omit the user_path in the redirect, writing simply redirect_to @user to redirect to the user show page
      flash[:success] = "User created successfully! You are now one of us!"
      redirect_to @user
    else
      render 'new'
    end
  end
end
