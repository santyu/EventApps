module Api
  module V1
    class TwittersController < ApplicationController
      before_action :check_params, only: :index
  
      def index
        @twitters = TwitterAPI.get_tweets(params[:query], params[:geocode], params[:type]) 
        
        # 動画のみの投稿に絞る
        @twitters.keep_if { |tweet| tweet.media.first.present? && tweet.media.first.expanded_url.to_s.include?('video') }

        # レスポンスボディの要素
        twitter = { count: @twitters.count, query: params[:query], geocode: params[:geocode], type: params[:type], data: data = {} }

        @twitters.each_with_index do |tweet, index|
          data[index] = { 
              tweet_id:   tweet.id,
              created_at: tweet.created_at.to_s,
              account:    tweet.user.screen_name,
              contents:   tweet.full_text,
              thumb_url:  tweet.media.first.media_url.to_s,
              video_url:  tweet.media.first.expanded_url.to_s,
              player_url: tweet.media.first.video_info.variants.first.url.to_s,
            }
        end
       
        render json: { status: 200, message: 'OK', twitter: twitter }
      end

      private
      def check_params
        params[:query] ||= ''
        params[:type]  ||= 'mixed'
        params[:geocode] ||= nil
      end

    end
  end
end
