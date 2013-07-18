class FlashCard < ActiveRecord::Base
  has_many :examples
    attr_accessible :examples_attributes
    accepts_nested_attributes_for :examples

  belongs_to :teachable, :polymorphic => true

  # TODO Fields
  attr_accessible :meaning, :part_of_speech
end
