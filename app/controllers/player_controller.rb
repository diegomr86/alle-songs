# encoding: UTF-8

require 'open-uri'
class PlayerController < ApplicationController

  def index
    if params[:music]

      @music_info = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(params[:artist])}&mus=#{URI::escape(params[:music])}&extra=alb,ytid").read)
    end

    respond_to do |format|
      format.html do
        redirect_to root_path, notice: 'Página não encontrada'
      end
    end
    bots = []
    csv.each do |row|
      bots.push(row[6]) unless bots.include?(row[6])
    end
    bots
  end
end
