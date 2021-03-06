module Api
  module V1
    class TwittersController < ApplicationController
      # GET /api/v1/twitters
      def index
        client = Twitter::REST::Client.new(
          consumer_key:        ENV['TW_CONSUMER_KEY'],
          consumer_secret:     ENV['TW_CONSUMER_SECRET'],
          access_token:        ENV['TW_ACCESS_TOKEN'],
          access_token_secret: ENV['TW_ACCESS_TOKEN_SECRET']
        )

        # 公式RTなしの最新のリンク付きの投稿を100件(GET最大値)取得する
        # geocode 例) 35.681382,139.766084,20km "緯度,経度,距離" のフォーマット
        options = { geocode: params[:geocode], result_type: 'recent', count: 100, exclude: 'retweets', filter: 'links' }
        tweets = client.search(params[:query], options).take(100)
        # 動画のある投稿に絞る
        tweets.keep_if { |tweet| tweet.media.first.present? && tweet.media.first.expanded_url.to_s.include?('video') }

        # 位置情報を含む投稿に絞る
        tweets.keep_if { |tweet| tweet.user.status.place.bounding_box.coordinates.present? }

        data = []
        tweets.each do |tweet|
          data << {
            tweet_id:      tweet.id,
            created_at:    tweet.created_at.to_s,
            account:       tweet.user.screen_name,
            contents:      tweet.full_text,
            thumb_url:     tweet.media.first.media_url.to_s,
            video_url:     tweet.media.first.expanded_url.to_s,
            player_url:    tweet.media.first.video_info.variants.first.url.to_s,
            location_name: tweet.user.status.place.full_name,
            location_code: tweet.user.status.place.bounding_box.coordinates
          }
        end

        render json: data
      end
    end
  end
end
