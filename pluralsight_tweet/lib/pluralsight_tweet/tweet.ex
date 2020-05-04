defmodule PluralsightTweet.Tweet do
  def send(str) do
    ExTwitter.configure(
      :process,
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_KEY"),
      access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )

    ExTwitter.update(str)
  end
end