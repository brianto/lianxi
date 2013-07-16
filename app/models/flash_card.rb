class FlashCard < ActiveRecord::Base
  has_many :examples

  belongs_to :teachable, :polymorphic => true

  # TODO Fields
  attr_accessible :meaning, :part_of_speech
end
