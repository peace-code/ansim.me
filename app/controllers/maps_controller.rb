class MapsController < ApplicationController
  def hospitals
      @type = params[:type] || 'antibiotics'
  end
end