module Api
  module V1
    class InstagramsController < ApplicationController
			
      # GET /api/v1/instagrams/
      def index
        @instagrams = Instagram.tag_recent_media(params[:query])

        render json: @instagrams
      end

      def show
      end
    end
  end
end
