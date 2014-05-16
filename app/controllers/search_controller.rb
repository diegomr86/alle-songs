require 'open-uri'

class SearchController < ApplicationController

  layout false

  include RockstarHelper

  def index
    @search_result = search_artist(params[:query])
    respond_to do |format|
      format.html
      format.json { render json: @search_result.to_json }
    end
  end

end
