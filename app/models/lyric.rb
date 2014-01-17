class Lyric < ActiveRecord::Base
  belongs_to :song

  def lines
    [ timing.split("\n"),
      simplified.split("\n"),
      traditional.split("\n"),
      translation.split("\n") ].transpose.map do |things|
        line = Line.new
        line.timing = things[0]
        line.simplified = things[1]
        line.traditional = things[2]
        line.translation = things[4]
        line
    end
  end
end

class Line
  def formatted_timing
    Time.at(@timing.to_f).utc.strftime "%M:%S"
  end
end
