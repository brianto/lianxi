class LinkExampleToFlashCards < ActiveRecord::Migration
  def change
    add_column :examples, :flash_card_id, :integer
    add_column :examples, :flash_card_type, :string
  end
end
