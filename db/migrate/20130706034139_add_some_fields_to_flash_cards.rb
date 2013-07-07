class AddSomeFieldsToFlashCards < ActiveRecord::Migration
  def change
    add_column :flash_cards, :meaning, :string
    add_column :flash_cards, :part_of_speech, :string
  end
end
