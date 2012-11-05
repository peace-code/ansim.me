class PlacesController < ApplicationController
  def index
    type = params[:type]

    north_east = params[:north_east].split(',').map(&:to_f) if params[:north_east]
    south_west = params[:south_west].split(',').map(&:to_f) if params[:south_west]

    if north_east and south_west
      places = Place.type(type).where(coordinates: {'$within' => {'$box' => [south_west, north_east]}}).limit(300)
    end

    render json: places
  end

  def show
    place = Place.find(params[:id])
    render json: place
  end
end