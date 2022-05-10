# frozen_string_literal: true

module RandomExtensions
  # https://stackoverflow.com/questions/5825680/code-to-generate-gaussian-normally-distributed-random-numbers-in-ruby
  def gaussian(mean, stddev)
    theta = 2 * Math::PI * rand
    rho = Math.sqrt(-2 * Math.log(1 - rand))
    scale = stddev * rho
    mean + (scale * Math.cos(theta))
  end
end

class Random
  extend RandomExtensions
end
