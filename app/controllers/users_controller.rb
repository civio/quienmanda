class UsersController < ApplicationController

  # GET /user/1
  # GET /user/1.json
  def show
    @user = User.find(params[:id])
    if current_user.nil? 
      redirect_to '/login'
    elsif current_user != @user 
      redirect_to '/'
    end
  end
end