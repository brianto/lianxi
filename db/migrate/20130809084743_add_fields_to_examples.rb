class AddFieldsToExamples < ActiveRecord::Migration
  def change
    add_column :examples, :simplified, :text, :null => false
    add_column :examples, :traditional, :text, :null => false
    add_column :examples, :pinyin, :text, :null => false
    add_column :examples, :zhuyin, :text, :null => false
    add_column :examples, :jyutping, :text, :null => false

    add_column :examples, :translation, :text, :null => false
    add_column :examples, :notes, :text
  end
end
