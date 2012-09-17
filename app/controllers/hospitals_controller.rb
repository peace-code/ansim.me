class HospitalsController < ApplicationController
  # GET /hospitals
  # GET /hospitals.json
  def index
    @north_east = params[:north_east].split(',').map(&:to_f) if params[:north_east]
    @south_west = params[:south_west].split(',').map(&:to_f) if params[:south_west]

    if @north_east && @south_west
      @hospitals = Hospital.where(coordinates: {'$within' => {'$box' => [@south_west, @north_east]}}).limit(300)
    else
      @search_name = params[:search_name]
      @hospitals = Hospital.where(name: /#{@search_name}/) if @search_name
      @hospitals = @hospitals.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hospitals }
    end
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
  def show
    @hospital = Hospital.find(params[:id])

    logger.info @hospital

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hospital }
    end
  end
end