class Example < ActiveRecord::Base
  belongs_to :flash_card

  # TODO better validators
  validates :traditional, :simplified, :presence => true
  validates :pinyin, :jyutping, :presence => true
  validates :translation, :presence => true

  def user
    return self.flash_card.user
  end
end
