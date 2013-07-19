class FlashCard < ActiveRecord::Base
  has_many :examples
    attr_accessible :examples_attributes
    accepts_nested_attributes_for :examples

  belongs_to :teachable, :polymorphic => true

  attr_accessible :traditional, :simplified
  attr_accessible :pinyin, :zhuyin, :jyutping
  attr_accessible :meaning, :part_of_speech
end
