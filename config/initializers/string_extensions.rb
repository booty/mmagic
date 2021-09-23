# frozen_string_literal: true

module StringExtensions
  SMALL_WORDS = %w{a an and as at but by en for if in of on or the to v v. via vs vs.}.freeze

  def possessive
    self + ('s' == self[-1,1] ? "'" : "'s")
  end

  def smart_titleize
    words = self.split(" ")

    words.each_with_index.map do |word, index|
      if (word.upcase == word)
        word
      elsif index > 0 && SMALL_WORDS.include?(word.downcase)
        word.downcase
      else
        word[0] = word[0].upcase
        word
      end
    end.join(" ")
  end
end

class String
  include StringExtensions
end
