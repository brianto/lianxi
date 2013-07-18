class Song < ActiveRecord::Base
  has_many :flash_cards, :as => :teachable
    attr_accessible :flash_cards_attributes
    accepts_nested_attributes_for :flash_cards

  accepts_nested_attributes_for :flash_cards

  # TODO Fields
  attr_accessible :title, :artist, :url
end
