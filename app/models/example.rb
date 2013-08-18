class Example < ActiveRecord::Base
  belongs_to :flash_card
    attr_accessible :flash_card_id

  attr_accessible :traditional, :simplified
  attr_accessible :pinyin, :jyutping
  attr_accessible :translation, :notes

  validates :traditional, :simplified, :presence => true
  validates :pinyin, :jyutping, :presence => true
  validates :translation, :presence => true
end
