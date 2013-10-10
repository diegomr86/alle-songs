# encoding: UTF-8

require 'open-uri'

class ArtistController < ApplicationController


  def index

    @img_url = "http://s2.vagalume.com"


    s = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(params[:artist])}").read) if params[:artist].present?

    if s.present? && s["art"].present?
      @url = s["art"]["url"]
      @artist = JSON.parse(open("#{@url}/index.js").read)["artist"]
      @discography = JSON.parse(open("#{@url}/discografia/index.js").read)["discography"]
      if @discography['item'].blank?
        @discography['item'] = [{
                                    'desc' => @artist['desc'],
                                    'cover' => @artist['pic_medium'],
                                    'discs' => [
                                        @artist['lyrics']['item']
                                    ]
                                }]
      end
      @genres = @artist['genre'].collect{|g| g['name']} if @artist['genre']
      respond_to do |format|
        format.html
        format.json {render json: [@discography, @artist]}
        format.xml {render :xml => @artist}
      end

    else
      redirect_to root_path, notice: 'Nenhuma música encontrada para este artista'
    end


  end

  def show

  end
end
