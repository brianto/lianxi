class FlashCard < ActiveRecord::Base
  # Model Relations
  has_many :examples
  belongs_to :teachable, :polymorphic => true

  # Fields
end
