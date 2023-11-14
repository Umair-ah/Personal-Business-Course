class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end
