module Api
  module V1
    class InstagramsController < ApplicationController
      def index
        @instagrams = Instagram.tag_recent_media(params[:query])
        # @instagrams = Instagram.location_recent_media()
        render json: @instagrams
      end

      def show
      end
    end
  end
end
