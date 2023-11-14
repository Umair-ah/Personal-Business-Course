class CreateTuts < ActiveRecord::Migration[7.0]
  def change
    create_table :tuts do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
