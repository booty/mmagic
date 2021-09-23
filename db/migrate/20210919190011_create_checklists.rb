class CreateChecklists < ActiveRecord::Migration[6.1]
  def change
    create_table :checklists do |t|
      t.integer :parent_id
      t.integer :place_id, null: false
      t.string :name, null: false
      t.json :contents
      t.datetime :published_at
      t.timestamps
    end
  end
end
