# frozen_string_literal: true

module HashExtensions
  def juice
    each do |k, v|
      if v.is_a?(Hash)
        self[k] = v.juice
      elsif v.respond_to?(:call)
        self[k] = v.call
      end
    end
  end

  def sample
    self[keys.sample]
  end
end

class Hash
  include HashExtensions
end

# TODO: make actual test
#
# hashes = [
#   { a: 1, b: 2, c: 3 },
#   { d: 1, e: { f: 1, g: 2, h: 3 } },
#   { i: 1, j: { k: { l: 2 } } },
#   {
#     m: 1,
#     n: -> { rand(1..99) },
#     o: -> { Time.now },
#   },
#   {
#     p: -> { rand(1..99) },
#     q: {
#       r: {
#         s: -> { Time.now },
#       },
#       t: 1,
#     },
#   },
# ]
# hashes.each { |x| puts x.juice }
