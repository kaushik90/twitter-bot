require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
  	get :home
  	assert_response :success
  	assert_select "title", "Home | Stay-Productive"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Stay-Productive"
  end

  test "should get contact" do
  	get :contact
  	assert_response :success
  	assert_select "title", "Contact | Stay-Productive"
  end

end
