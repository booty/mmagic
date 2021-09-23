class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.integer :parent_id
      t.integer :place_type, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
