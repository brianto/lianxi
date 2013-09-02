class CreateLyrics < ActiveRecord::Migration
  def change
    create_table :lyrics do |t|
      t.text :traditional
      t.text :simplified
      t.text :pronunciation
      t.string :dialect
      t.text :translation
      t.string :timing

      t.references :song

      t.timestamps
    end
  end
end
