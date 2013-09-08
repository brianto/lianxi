module SongsHelper
  def inject_tooltip_hints(line, cards)
    # Make lookup table
    lookup = cards.inject(Hash.new) do |table, card|
      table[card.traditional] = card
      table[card.simplified] = card

      table
    end

    # Do substitutions
    return line.gsub(/\[([^\[\]]*)\]/) do |match|
      # TODO un-uglify ternary
      lookup[$1] ? controller.render_to_string(:partial => "tooltip", :locals => {
        :card => lookup[$1],
        :character => $1
      }).strip : match
    end.html_safe
  end

  def render_lyrics(song)
    render :partial => "lyrics", :locals => {
      :song => song
    }
  end
end
