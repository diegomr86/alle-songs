require 'open-uri'

class HomeController < ApplicationController

  layout 'application', only: :index

  def index
    respond_to do |format|
      format.html
    end
  end

end
