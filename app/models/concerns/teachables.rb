module Teachables
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    has_many :pins, :as => :teachable

    has_many :flash_cards, :as => :teachable
    accepts_nested_attributes_for :flash_cards
  end

  def pinned_by?(user)
    self.pins.find_by(:user => user).present?
  end
end
