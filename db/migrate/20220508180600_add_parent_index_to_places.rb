class AddParentIndexToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_index :places, :parent_id
  end
end
