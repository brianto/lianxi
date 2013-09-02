class Lyric < ActiveRecord::Base
  belongs_to :song

  attr_accessible :dialect, :pronunciation,
    :simplified, :timing, :traditional, :translation

  def lines
    [ timing.split("\n"),
      simplified.split("\n"),
      traditional.split("\n"),
      pronunciation.split("\n"),
      translation.split("\n") ].transpose.map do |things|
        line = Line.new
        line.timing = things[0]
        line.simplified = things[1]
        line.traditional = things[2]
        line.pronunciation = things[3]
        line.translation = things[4]
        line
    end
  end
end

class Line
  attr_accessor :simplified, :traditional,
    :pronunciation, :timing, :translation
end
