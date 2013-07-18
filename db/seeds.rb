# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Drill.create({
  :title => "Food and Cooking",
  :description => "Chinese cuisine foods",
  :flash_cards_attributes => [
    { :meaning => "stir fry", :part_of_speech => "adjective" },
    { :meaning => "to fry", :part_of_speech => "verb" }
  ]
})

Drill.create({
  :title => "Sports and Activities",
  :description => "American sports",
  :flash_cards_attributes => [
    { :meaning => "tennis", :part_of_speech => "noun" },
    { :meaning => "to kick", :part_of_speech => "verb" }
  ]
})

Song.create({
  :title => "Windy Season 風的季節",
  :artist => "Paula Tsui 甄妮",
  :url => "http://www.youtube.com/watch?v=KQ2W1RbwsRw",
  :flash_cards_attributes => [
    { :meaning => "cold", :part_of_speech => "adjective" },
    { :meaning => "lightly", :part_of_speech => "adjective" }
  ]
})

Song.create({
  :title => "Love You Ten Thousand Years 愛你一萬年",
  :artist => "Jenny Tseng 徐小鳳",
  :url => "http://www.youtube.com/watch?v=pwzZ5em0Erg",
  :flash_cards_attributes => [
    { :meaning => "ten thousand", :part_of_speech => "noun" },
    { :meaning => "to forget", :part_of_speech => "verb" }
  ]
})
