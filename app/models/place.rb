# frozen_string_literal: true

# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  place_type :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
class Place < ApplicationRecord
  has_closure_tree

  enum place_type: { corporation: 0, grouping: 1, facility: 2, restaurant: 3 }

  belongs_to :parent, class_name: "Place", optional: true
end
