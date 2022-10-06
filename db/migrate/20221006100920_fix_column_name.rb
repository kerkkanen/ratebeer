class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :beers, :style, :old_style
  end
end
