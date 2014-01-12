class Passage < ActiveRecord::Base
  belongs_to :user

  has_many :flash_cards, :as => :teachable

  validates :title, :presence => true
end
