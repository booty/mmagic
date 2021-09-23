# frozen_string_literal: true

class Place < ApplicationRecord
  enum place_type: { corporation: 0, grouping: 1, facility: 2, restaurant: 3 }

  belongs_to :parent, class_name: "Place", optional: true

  def hello
    "hi!"
  end
end