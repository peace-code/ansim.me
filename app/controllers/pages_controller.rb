class PagesController < ApplicationController
  def home
  	@type = params[:type]
  end
end