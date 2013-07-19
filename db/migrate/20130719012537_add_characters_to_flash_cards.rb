class AddCharactersToFlashCards < ActiveRecord::Migration
  def change
    add_column :flash_cards, :simplified, :string
    add_column :flash_cards, :traditional, :string
    add_column :flash_cards, :pinyin, :string
    add_column :flash_cards, :zhuyin, :string
    add_column :flash_cards, :jyutping, :string
  end
end
