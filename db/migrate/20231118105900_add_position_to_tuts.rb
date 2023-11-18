class AddPositionToTuts < ActiveRecord::Migration[7.0]
  def change
    add_column :tuts, :position, :integer
  end
end
