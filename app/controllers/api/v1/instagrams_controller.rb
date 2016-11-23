module Api
  module V1
    class InstagramsController < ApplicationController
      # GET /api/v1/instagrams/
      def index
        file = open('https://taglive.jp/wp/tglv_json/test.json')
        data = file.read.gsub('taglive_data=', '')
        hash = JSON.parse(data.chop)
        render json: hash.select { |line| line['video'].to_i == 1 }
      end

      def show
      end
    end
  end
end
