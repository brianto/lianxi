class Difficulty < ActiveRecord::Base
  belongs_to :user
  belongs_to :flash_card
end
