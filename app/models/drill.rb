class Drill < ActiveRecord::Base
  include Teachables

  validates :title, :presence => true
end
