class Hospital
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  field :name
  field :description
  field :phone
  field :homepage

  field :address
  field :coordinates, type: Array

  index({ coordinates: "2d" })
end