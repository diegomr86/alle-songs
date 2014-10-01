require 'open-uri'

class SearchController < ApplicationController

  include RockstarHelper

  def index

    @search_result = []

    @search_result = autocomplete(params[:autocomplete]) if params[:autocomplete].present?
    @search_result = search_artist(params[:artist]) if params[:artist].present?
    @search_result = search_album(params[:album]) if params[:album].present?

    respond_to do |format|
      format.html
      format.json { render json: @search_result.to_json }
    end
  end

end
