class FacebookController < ApplicationController
  respond_to :json
  def fetch
    access_token = params['accessToken']

    begin
      @user = FbGraph::User.me(access_token).fetch
      puts 'aaaaa'
      puts @user
    rescue => the_error
      @error = the_error.message
      puts "Error #{the_error.message}"
    end

    if @user && @user.email
      respond_with(@user || @error)
    end
  end
end