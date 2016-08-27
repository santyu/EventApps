module Api
  module V1
    class TwittersController < ApplicationController
  
      def index
        # パラメータは指定がなくても動く
        @twitters = TwitterAPI.get_tweets(params[:query], params[:geocode], params[:type]) 
        # 動画のみの投稿に絞る
        @twitters.keep_if { |tweet| tweet.media.first.present? && tweet.media.first.expanded_url.to_s.include?('video') }
        
        render json: @twitters
      end

      def show
    
      end

    end
  end
end
