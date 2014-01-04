class Drill < ActiveRecord::Base
  belongs_to :user

  has_many :flash_cards, :as => :teachable

  attr_accessor :title, :description

  validates :title, :presence => true
end
