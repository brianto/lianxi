class Example < ActiveRecord::Base
  belongs_to :flash_card

  attr_accessor :traditional, :simplified
  attr_accessor :pinyin, :jyutping
  attr_accessor :translation, :notes

  # TODO better validators
  validates :traditional, :simplified, :presence => true
  validates :pinyin, :jyutping, :presence => true
  validates :translation, :presence => true

  def user
    return self.flash_card.user
  end
end
