class FlashCard < ActiveRecord::Base
  has_many :examples

  belongs_to :teachable, :polymorphic => true

  # TODO make a better version of this
  validates :traditional, :simplified, :presence => true
  validates :pinyin, :jyutping, :presence => true
  validates :meaning, :part_of_speech, :presence => true

  def user
    return self.teachable.user
  end
end
