# frozen_string_literal: true

# The Board class represents the visual and structural state of the game.
# It is responsible for storing the history of guesses and their
# corresponding feedback (black and white pins).
#
# This class ensures that the game data is organized for the
# Sinatra views to render the board correctly.
#
class Game
  attr_reader :board, :secret_code, :current_attempt

  def initialize(attempts = 10, custom_code = nil)
    @board = Board.new(attempts)
    @secret_code = custom_code || generate_random_code
  end

  def play_attempt(guess)
    feedback = calculate_feedback(guess)

    return false unless @board.place_items?(guess, feedback)

    feedback
  end

  def won?(feedback)
    feedback[:black] == 4
  end

  def lost?
    @board.game_over? && !won_last_attempt?
  end

  def generate_random_code
    Array.new(4) { Board::AVAILABLE_COLORS.sample }
  end

  def calculate_feedback(guess)
    secret_copy = @secret_code.dup
    guess_copy = guess.dup

    black_pins = count_black_pins!(guess_copy, secret_copy)
    white_pins = count_white_pins!(guess_copy, secret_copy)

    { black: black_pins, white: white_pins }
  end

  def won_last_attempt?
    @board.hints.any? { |hint| hint && hint[:black] == 4 }
  end

  private

  def count_black_pins!(guess, secret)
    count = 0
    guess.each_with_index do |color, index|
      next unless color == secret[index]

      count += 1
      guess[index] = nil
      secret[index] = nil
    end
    count
  end

  def count_white_pins!(guess, secret)
    count = 0
    guess.compact.each do |color|
      if secret.include?(color)
        count += 1
        secret[secret.index(color)] = nil
      end
    end
    count
  end
end
