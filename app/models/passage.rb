class Passage < ActiveRecord::Base
  has_many :flash_cards, :as => :teachable

  # Fields
end
