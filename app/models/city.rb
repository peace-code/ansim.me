class City
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :city
  field :subcity

  field :address
  field :coordinates, type: Array

  geocoded_by :address
  after_validation :geocode

  index({ coordinates: "2d" })

  # methods
  def self.cities
  	self.where(subcity: nil)
  end

  def subcities
    City.where(city: self.city, subcity: { '$ne' => nil } )
  end
end