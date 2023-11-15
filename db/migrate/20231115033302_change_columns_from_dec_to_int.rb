class ChangeColumnsFromDecToInt < ActiveRecord::Migration[7.0]
  def change
    change_column :courses, :price, :integer
    change_column :payments, :price, :integer
  end
end
