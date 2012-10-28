class PlacesController < ApplicationController
  def index
    type = params[:type]
    places = Place.type(type)
    render json: places
  end
end