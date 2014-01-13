class CreateDifficulties < ActiveRecord::Migration
  def change
    create_table :difficulties do |t|
      t.string :difficulty
      t.references :user, index: true
      t.references :flash_card, index: true

      t.timestamps
    end
  end
end
