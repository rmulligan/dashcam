class Trip
  include Mongoid::Document

  field :start_time,    type: DateTime
  field :end_time,      type: DateTime
  field :frames,        type: Integer
  field :frame_rate,    type: Integer
  field :title,         type: String
  field :description,   type: String
  field :vid_location,  type: String

  embeds_many :moments
end
