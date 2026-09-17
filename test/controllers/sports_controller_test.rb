require "test_helper"

class SportsControllerTest < ActionDispatch::IntegrationTest
  test "should get baseball" do
    get sports_baseball_url
    assert_response :success
  end

  test "should get soccer" do
    get sports_soccer_url
    assert_response :success
  end

  test "should get basketball" do
    get sports_basketball_url
    assert_response :success
  end
end
