# frozen_string_literal: true

# == Schema Information
#
# Table name: checklist_items
#
#  id         :integer          not null, primary key
#  contents   :json             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  place_id   :integer          not null
#
# Indexes
#
#  index_checklist_items_on_place_id  (place_id)
#
class ChecklistItem < ApplicationRecord
end
