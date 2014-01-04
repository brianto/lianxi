class Passage < ActiveRecord::Base
  belongs_to :user

  has_many :flash_cards, :as => :teachable

  attr_accessor :title

  validates :title, :presence => true
end
