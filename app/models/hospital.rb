class Hospital
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  field :code
  field :category
  field :name
  field :description
  field :phone
  field :homepage
  field :antibiotics
  field :injections

  field :zipcode
  field :address
  field :coordinates, type: Array

  geocoded_by :address
  # after_validation :geocode

  index({ coordinates: "2d" })

  def self.categories
    Hospital.all.distinct(:category)
  end
end