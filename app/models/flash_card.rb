class FlashCard < ActiveRecord::Base
  has_many :examples
    attr_accessible :examples_attributes
    accepts_nested_attributes_for :examples

  belongs_to :teachable, :polymorphic => true
    attr_accessible :teachable_id, :teachable_type

  attr_accessible :traditional, :simplified
  attr_accessible :pinyin, :jyutping
  attr_accessible :meaning, :part_of_speech

  validates :traditional, :simplified, :presence => true
  validates :pinyin, :jyutping, :presence => true
  validates :meaning, :part_of_speech, :presence => true
end
