class TweetsController < ApplicationController
  def create
    if location_params.keys.blank?
      render json: { error: 'provide a valid param to search a city' },
             status: :bad_request 
    else
      tweet = WeatherTweetterService.call(location_params)

      render json: { tweet: tweet }, status: :ok
    end
  end

  private

  def location_params
    params.permit(:q, :id, :zip, :lat, :lon)
  end
end