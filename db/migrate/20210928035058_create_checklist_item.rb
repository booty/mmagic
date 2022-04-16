class CreateChecklistItem < ActiveRecord::Migration[6.1]
  def change
    create_table :checklist_items do |t|
      t.integer :place_id, null: false, index: true
      t.json :contents, null: false
      t.timestamps
    end
  end
end
