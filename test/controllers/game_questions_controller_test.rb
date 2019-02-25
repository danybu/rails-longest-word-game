require 'test_helper'

class GameQuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get game_questions_new_url
    assert_response :success
  end

  test "should get score" do
    get game_questions_score_url
    assert_response :success
  end

end
