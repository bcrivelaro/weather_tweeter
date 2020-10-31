class TweetController < ApplicationController
  def create
    tweet = WeatherTweetterService.call(location_params)

    render json: { tweet: tweet }, status: :ok
  end

  private

  def location_params
    params.permit(:q, :id, :zip, :lat, :lon)
  end
end