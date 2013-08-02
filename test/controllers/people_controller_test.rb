require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = entities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end
end
