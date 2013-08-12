class Example < ActiveRecord::Base
  belongs_to :flash_card
    attr_accessible :flash_card_id

  attr_accessible :traditional, :simplified
  attr_accessible :pinyin, :zhuyin, :jyutping
  attr_accessible :translation, :notes

  validates :traditional, :simplified, :presence => true
  validates :pinyin, :zhuyin, :jyutping, :presence => true
  validates :translation, :presence => true
end
