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
      controller.render_to_string(:partial => "tooltip", :locals => {
        :card => lookup[$1],
        :character => $1
      }).strip
    end.html_safe
  end
end
