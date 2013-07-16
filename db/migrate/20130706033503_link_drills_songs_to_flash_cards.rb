class LinkDrillsSongsToFlashCards < ActiveRecord::Migration
  def up
    add_column :flash_cards, :teachable_id, :integer
    add_column :flash_cards, :teachable_type, :string
  end

  def down
    remove_column :flash_cards, :teachable_id
    remove_column :flash_cards, :teachable_type
  end
end
