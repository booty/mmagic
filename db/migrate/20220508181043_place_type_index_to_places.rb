class PlaceTypeIndexToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_index :places, :place_type
  end
end
