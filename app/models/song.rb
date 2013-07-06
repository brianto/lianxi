class Song < ActiveRecord::Base
  # Model Relations
  has_many :flash_cards, :as => :teachable

  # Fields
  attr_accessible :title, :artist, :url
end
