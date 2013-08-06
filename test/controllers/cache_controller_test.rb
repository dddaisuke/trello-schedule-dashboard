require 'test_helper'

class CacheControllerTest < ActionController::TestCase
  test "should get clear" do
    get :clear
    assert_response :success
  end

end
