# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Drill.create({
  :title => "Food and Cooking",
  :description => "Chinese cuisine foods",
  :flash_cards_attributes => [
    { :simplified => "烧", :traditional => "燒",
      :pinyin => "shāo", :zhuyin => "ㄕㄠ", :jyutping => "siu1",
      :meaning => "roast", :part_of_speech => "verb" },
    { :simplified => "炒", :traditional => "炒",
      :pinyin => "chǎo", :zhuyin => "ㄔㄠˇ", :jyutping => "caau2",
      :meaning => "to fry", :part_of_speech => "verb" }
  ]
})

Drill.create({
  :title => "Sports and Activities",
  :description => "American sports",
  :flash_cards_attributes => [
    { :simplified => "网球", :traditional => "網球",
      :pinyin => "wǎng qiú", :zhuyin => "ㄨㄤˇ ㄑㄧㄡˊ", :jyutping => "mong5 kau4",
      :meaning => "tennis", :part_of_speech => "noun" },
    { :simplified => "踢", :traditional => "踢",
      :pinyin => "tī", :zhuyin => "ㄊㄧ", :jyutping => "tek3",
      :meaning => "to kick", :part_of_speech => "verb" }
  ]
})

Song.create({
  :title => "Windy Season 風的季節",
  :artist => "Paula Tsui 甄妮",
  :url => "http://www.youtube.com/embed/KQ2W1RbwsRw",
  :flash_cards_attributes => [
    { :simplified => "涼", :traditional => "涼",
      :pinyin => "liáng", :zhuyin => "ㄌㄧㄤˊ", :jyutping => "loeng4",
      :meaning => "cold", :part_of_speech => "adjective" },
    { :simplified => "轻", :traditional => "輕",
      :pinyin => "qīng", :zhuyin => "ㄑㄧㄥ", :jyutping => "hing1",
      :meaning => "lightly", :part_of_speech => "adjective" }
  ]
})

Song.create({
  :title => "Love You Ten Thousand Years 愛你一萬年",
  :artist => "Jenny Tseng 徐小鳳",
  :url => "http://www.youtube.com/embed/pwzZ5em0Erg",
  :flash_cards_attributes => [
    { :simplified => "一万", :traditional => "一萬",
      :pinyin => "yī wàn", :zhuyin => "ㄧ ㄨㄢˋ", :jyutping => "jat1 maan6",
      :meaning => "ten thousand", :part_of_speech => "noun" },
    { :simplified => "忘记", :traditional => "忘記",
      :pinyin => "wàng jì", :zhuyin => "ㄨㄤˋ ㄐㄧˋ", :jyutping => "mong4 gei3",
      :meaning => "to forget", :part_of_speech => "verb" }
  ]
})
