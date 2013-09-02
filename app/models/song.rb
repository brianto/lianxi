class Song < ActiveRecord::Base
  belongs_to :user
    attr_accessible :user

  has_many :flash_cards, :as => :teachable
    attr_accessible :flash_cards_attributes
    accepts_nested_attributes_for :flash_cards

  has_one :lyric
    attr_accessible :lyric_attributes
    accepts_nested_attributes_for :lyric

  attr_accessible :title, :artist, :url

  validates :title, :artist, :url, :presence => true
  # validates :lyric, :presence => true
end
