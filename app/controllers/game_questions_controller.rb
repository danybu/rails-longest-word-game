class GameQuestionsController < ApplicationController
  def new
    nr_of_letters = 10
    @grid = []
    nr_of_letters.times do
      @grid << ('a'..'z').to_a.sample.upcase;
    end
    session[:start_time] = Time.now
  end

  def score
    @guess = params[:guess].gsub(/\s/, '')
    @grid = params[:grid]
    @end_time = Time.now
    @time = @end_time - Time.parse(session[:start_time])
    @result = { score: 0, time: @time }
    wrong_attempt = wrong_attempt?(@grid.downcase, @guess.downcase)
    if wrong_attempt
      @result[:message] = wrong_attempt
    else
      @result[:score] = (@guess.size - @time * 0.02)
      @result[:message] = 'Well Done!'
    end
  end
end

# is the attempt valid, i.e.: contained in grid, and valid english
# error_message == nil when ok, otherwise
# expects downcased attempt en grid strings
# TODO: betere errormessage
def wrong_attempt?(grid, attempt)
  if attempt.match?(/[^a-z]/)
    return "not an english word"
  elsif attempt.empty?
    return "you didnt give any input, man"
  elsif not_in_grid?(grid, attempt)
    return "not in the grid"
  elsif not_in_dictionary_api?(attempt)
    return not_in_dictionary_api?(attempt)
  end
  return nil
end

def not_in_grid?(grid, attempt)
  grid_array = grid.split('')
  # binding.pry
  attempt.split('').each do |attempt_letter|
    found_index = grid_array.find_index(attempt_letter)
    if !found_index
      return true
    else
      grid_array.delete_at(found_index)
    end
  end
  return false
end

# return nil if OK, error message otherwise
def not_in_dictionary_api?(attempt)
  url = "https://wagon-dictionary.herokuapp.com/" + attempt
  looked_up_serialized = open(url).read
  looked_up_hash = JSON.parse(looked_up_serialized)
  if looked_up_hash["found"]
    return nil
  else
    return "not an english word"
  end
end
