class CreateFlashCards < ActiveRecord::Migration
  def change
    create_table :flash_cards do |t|

      t.timestamps
    end
  end
end
