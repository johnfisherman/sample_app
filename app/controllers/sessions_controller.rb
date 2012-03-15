# session management follows RESTful paradigm
class SessionsController < ApplicationController
  # render sign in form
  def new
  end

  # POST request to /sessions via form
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page. Method present at session_helper.rb
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
