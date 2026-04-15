# frozen_string_literal: true

# Represents the Mastermind board and handles its state and display logic.
class Board
  attr_reader :grid, :current_attempt, :hints

  AVAILABLE_COLORS = %i[red blue green yellow white black].freeze

  def initialize(attempts = 10)
    @grid = Array.new(attempts) { Array.new(4, nil) }
    @hints = Array.new(attempts) { { black: 0, white: 0 } }
    @current_attempt = 0
  end

  def place_items?(colors, feedback)
    return false unless valid_colors?(colors) && !game_over?

    @grid[@current_attempt] = colors
    @current_attempt += 1
    @hints[@current_attempt] = feedback
    true
  end

  def game_over?
    @current_attempt >= @grid.size
  end

  private

  def valid_colors?(colors)
    colors.all? { |color| AVAILABLE_COLORS.include?(color.to_sym) }
  end
end
