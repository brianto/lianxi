class RemoveZhuyinField < ActiveRecord::Migration
  def change
    remove_column :flash_cards, :zhuyin
    remove_column :examples, :zhuyin
  end
end
