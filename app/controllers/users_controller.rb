class UsersController < ApplicationController

  def index
    @user = current_user
    if @user.present?
      render :json => @user
    else
      render :json => nil, :status => 422
    end
  end

end
