class DropPronunciationForAllExceptFlashCards < ActiveRecord::Migration
  def change
    remove_column :examples, :pinyin
    remove_column :examples, :jyutping

    remove_column :lyrics, :pronunciation
  end
end
