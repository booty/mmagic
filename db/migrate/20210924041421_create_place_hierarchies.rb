class CreatePlaceHierarchies < ActiveRecord::Migration[6.1]
  def change
    create_table :place_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :place_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "place_anc_desc_idx"

    add_index :place_hierarchies, [:descendant_id],
      name: "place_desc_idx"
  end
end
