class Song < ActiveRecord::Base
  belongs_to :user

  has_many :flash_cards, :as => :teachable

  has_one :lyric

  validates :title, :artist, :url, :presence => true
  # validates :lyric, :presence => true
end
