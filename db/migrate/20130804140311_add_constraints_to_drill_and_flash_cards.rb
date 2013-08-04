class AddConstraintsToDrillAndFlashCards < ActiveRecord::Migration
  def change
    change_column :drills, :title, :string, :null => false
    change_column :drills, :description, :string, :null => false

    change_column :flash_cards, :teachable_id, :integer, :null => false
    change_column :flash_cards, :teachable_type, :string, :null => false

    change_column :flash_cards, :simplified, :string, :null => false
    change_column :flash_cards, :traditional, :string, :null => false
    change_column :flash_cards, :pinyin, :string, :null => false
    change_column :flash_cards, :zhuyin, :string, :null => false
    change_column :flash_cards, :jyutping, :string, :null => false
    change_column :flash_cards, :part_of_speech, :string, :null => false
    change_column :flash_cards, :meaning, :string, :null => false
  end
end
