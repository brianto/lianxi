class Song < ActiveRecord::Base
  belongs_to :user

  has_many :flash_cards, :as => :teachable

  serialize :timing, Array

  validates :title, :artist, :youtubeId, :presence => true
  validates :simplified, :traditional, :timing, :presence => true
end
