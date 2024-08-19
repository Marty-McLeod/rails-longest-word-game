require "json"
require "open-uri"
URL = "https://dictionary.lewagon.com/"

class GamesController < ApplicationController
  def new
    @charset = Array("A".."Z")
    @letters = Array.new(10) { @charset.sample }
  end

  def score

    @word_guess = params[:word_entry]
    # Get the original letter array from NEW and remove all non-alph. chars
    # then convert to array of string chars.
    @letters_cleaned = params[:letters].gsub(/[^a-zA-Z]/, '')
    @letters_cleaned = @letters_cleaned.chars
    @word_guess = @word_guess.upcase
    @word_guess_array = @word_guess.chars
    @match_count = 0

    # Check for a valid word and return if not valid
    @user_serialized = URI.open("#{URL}#{@word_guess}").read
    @user = JSON.parse(@user_serialized)
    if @user[:found] == false
      @results_a = "Sorry but "
      @results_b = " isn't a valid word."
      return
    end

    # If a valid word, check for a match
    @word_guess_array.each do |item|
      if @letters_cleaned.include?(item)
        @match_count += 1
      else
        break
      end
    end
      # raise

    if @match_count == @word_guess_array.length
      @results_a = "Congratulations! "
      @results_b = " is a valid word!"
    else
      @results_a = "Sorry, "
      @results_b = " isn't in the word character list: #{@letters_cleaned.join(", ")}"
    end
  end
end
