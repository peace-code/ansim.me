class HospitalsController < ApplicationController
  # GET /hospitals
  # GET /hospitals.json
  def index
    @north_east = params[:north_east].split(',').map(&:to_f) if params[:north_east]
    @south_west = params[:south_west].split(',').map(&:to_f) if params[:south_west]

    puts params
    if @north_east && @south_west
      if params['mers'] == "true"
        @hospitals = Hospital.where({ :mers.ne => nil, coordinates: {'$within' => {'$box' => [@south_west, @north_east]}} }).limit(300)
      else
        @hospitals = Hospital.where(coordinates: {'$within' => {'$box' => [@south_west, @north_east]}}).limit(300)
      end
    else
      @search_name = params[:search_name]
      @hospitals = @search_name ? Hospital.where(name: /#{@search_name}/) : Hospital
      @hospitals = @hospitals.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hospitals }
    end
  end

  # example:
  # GET /hospitals/542bc05b49322892680000e4
  # GET /hospitals/542bc05b49322892680000e4.json
  def show
    @hospital = Hospital.find(params[:id])

    logger.info @hospital

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hospital }
    end
  end
end