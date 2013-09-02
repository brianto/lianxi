class Lyric < ActiveRecord::Base
  belongs_to :song

  attr_accessible :dialect, :pronunciation,
    :simplified, :timing, :traditional, :translation
end
