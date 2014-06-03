class Moment
  include Mongoid::Document
  field :coordinates, type: Array
  field :address, type: String
  field :speed, type: Float
  field :altitude, type: Float
  field :heading, type: Float
  field :climb, type: Float
  field :reference_id, type: Integer

  index({ location: "2d" }, { min: -200, max: 200 })

  embedded_in :trip
end
