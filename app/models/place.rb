class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  field :type
  field :name
  field :description
  field :info, type: Hash

  field :zipcode
  field :address
  field :coordinates, type: Array

  geocoded_by :address
  # after_validation :geocode

  index({ coordinates: "2d" })

  # scope
  def self.type(type)
    where(type: type)
  end
end