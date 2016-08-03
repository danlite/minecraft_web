class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :map_id
      t.integer :dimension_id
      t.integer :scale
      t.integer :height
      t.integer :width
      t.integer :center_x
      t.integer :center_z
      t.string :image

      t.timestamps null: false
    end
  end
end
