class FlashCard < ActiveRecord::Base
  # Model Relations
  # has_many :examples
  belongs_to :teachable, :polymorphic => true

  # Fields
  attr_accessible :meaning, :part_of_speech
end
