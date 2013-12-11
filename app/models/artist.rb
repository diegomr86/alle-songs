require "csv"
class Artist < ActiveRecord::Base

  def self.import(file)

    Artist.destroy_all
    CSV.read(file.path, :encoding => 'UTF-8', :skip_blanks => true).each do |row|

      if row[0] && row[0].index("/artist") != 0
        puts row[0]
        s = JSON.parse(open("http://www.vagalume.com.br/api/search.php?art=#{URI::escape(row[0])}").read) if row[0].present?

        if s.present? && s["art"].present?
          @url = s["art"]["url"]
          puts artist = JSON.parse(open("#{@url}/index.js").read)["artist"]
          puts @artist = Artist.where(
              :name => artist["desc"],
              :picture => artist["pic_medium"]
          ).first_or_create
        end

      end

    end
  end

end
