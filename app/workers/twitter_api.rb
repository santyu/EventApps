# -*- coding: utf-8 -*-
require 'twitter'
# ==============================================
# This software is licensed under the CC-GNU GPL
# http://tweet.rubyforge.org/
# ==============================================

module TwitterAPI
  def self.get_tweets(query, geocode, type)
    client = Twitter::REST::Client.new(
      consumer_key:         '',
      consumer_secret:      '',
      access_token:         '',
      access_token_secret:  '',
    )

    options = {
      geocode:      geocode,    # 緯度,経度,距離
      lang:         'ja',       # 言語
      locale:       'ja',       # 地域
      result_type:  type,       # 'recent' => 最近の投稿, 'popular' => 人気のツイート, 'mixed' => 全て（デフォルト） 
      count:        100,        # 取得数　最大取得件数は100件
      until:        '',         # 指定日検索　"YYYY-MM-DD" のフォーマットで指定　1週間までしか取得できない
      since_id:     nil,        # 指定 ID 以降から取得（最も古いツイートID）
      max_id:       nil,        # 指定 ID 以前を取得（最も新しいツイートID）
      from:         '',         # 指定アカウントからのツイートを検索
      to:           '',         # 指定アカウントへのツイートを検索
      exclude:      'retweets', # 除外　'retweet' => 公式RTを排除
      filter:       'links',    # 抽出　'links' => リンクを含むツイートのみを検索
    }

    # AND検索は、クエリをスペースで繋ぐ
    # NOT検索は、除外したいクエリの前に「-」をつける
    blacklist = ['-えろ ', '-しね ']
    words = blacklist.join(',')
    words << query
    tweets = client.search(words, options)
    tweets.take(options[:count])
  end
end
