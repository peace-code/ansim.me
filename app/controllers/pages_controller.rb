class PagesController < ApplicationController
  def home
  	@type = params[:type] || 'antibiotics'
  end
end