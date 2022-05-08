# frozen_string_literal: true

# == Schema Information
#
# Table name: checklists
#
#  id           :integer          not null, primary key
#  contents     :json
#  name         :string           not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  parent_id    :integer
#  place_id     :integer          not null
#
class Checklist < ApplicationRecord
  def merged_contents()
    # conn = ActiveRecord::Base.connection

    # list_data = conn.select_all(<<~SQL)
    #   SELECT
    #     descendant_id,
    #     -- ancestor_id,
    #     -- generations,
    #     cl.name,
    #     -- cl.contents
    #     group_concat(ancestor_id) as ancestor_ids,
    #     group_concat(contents) as contents,
    #     group_concat(generations) as generations
    #   FROM place_hierarchies ph
    #     inner join checklists cl on ph.ancestor_id = cl.place_id
    #     inner join places pl_a on ph.ancestor_id = pl_a.id
    #     inner join places pl_d on ph.descendant_id = pl_d.id
    #   WHERE cl.name = "#{name}" -- TODO: BIG SQL INJECTION HOLE
    #   GROUP BY descendant_id
    #   ORDER BY generations;
    # SQL

    # # list_data_grouped = list_data.group_by { |x| x["descendant_id"] }
    # list_data_indexed = list_data.index_by { |x| x["descendant_id"] }

    # # TODO: the group_by above screws up sorting
    # # need to resort data!!!! or else this is broke
    # # OR, use the commented out SQL grouping
    # list_data_indexed[242709].each_with_object({}) do |x, memo|
    #   parsed = JSON.parse(x["contents"])
    #   ap parsed
    #   # note to self: deep_merge! can also take a block, if we want to
    #   # customize the merge logic
    #   memo.deep_merge!(JSON.parse(x["contents"]))
    # end

    # binding.pry
    # "wow"
  end
end
