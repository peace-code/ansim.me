class Hospital
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  field :name
  field :description
  field :address
  field :coordinates, type: Array
end
