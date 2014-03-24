class Song < ActiveRecord::Base
  include Teachables

  serialize :timing, Array

  validates :title, :artist, :youtubeId, :presence => true
  validates :simplified, :traditional, :translation, :timing, :presence => true
end
