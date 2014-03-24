class Pin < ActiveRecord::Base
  belongs_to :user
  belongs_to :teachable, :polymorphic => true

  validates :user, :uniqueness => {
    :scope => [ :teachable_id, :teachable_type ] }

  def self.pinned
    where :pinned => true
  end
end
