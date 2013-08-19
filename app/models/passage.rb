class Passage < ActiveRecord::Base
  belongs_to :user
    attr_accessible :user

  has_many :flash_cards, :as => :teachable
    attr_accessible :flash_cards_attributes
    accepts_nested_attributes_for :flash_cards

  attr_accessible :title

  validates :title, :presence => true
end
