module Api
  module V1
    class TwittersController < ApplicationController
      before_action :check_query_existence, only: :index
  
      def index
        @twitters = TwitterAPI.get_tweets(params[:query], params[:geocode], params[:type]) 
        
        # 動画のみの投稿に絞る
        @twitters.keep_if { |tweet| tweet.media.first.present? && tweet.media.first.expanded_url.to_s.include?('video') }

        params[:geocode] ||= nil
        params[:type] ||= 'mixed'
        
        # レスポンスボディの要素
        twitter = { count: @twitters.count, query: params[:query], geocode: params[:geocode], type: params[:type], data: data = {} }
       
        @twitters.each_with_index do |tweet, index|
          data[index] = { 
              tweet_id:   tweet.id,
              created_at: tweet.created_at,
              account:    tweet.user.screen_name,
              contents:   tweet.full_text,
              video_url:  tweet.media.first.expanded_url.to_s,
            }
        end
       
        render json: { status: 200, message: 'OK', twitter: twitter }
      end

      private
      def check_query_existence
        # queryパラメータがないとTwitterAPIでエラーとなる
        return render json: { status: 404, message: 'Bad Request' } if params[:query].blank?
      end

    end
  end
end