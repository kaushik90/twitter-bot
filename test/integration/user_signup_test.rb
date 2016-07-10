require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "should not create User | bad form" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "",
                               password:              "",
                               password_confirmation: "" }
    end
    assert_template 'users/new'
  end

  test "should not create User | only name " do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "Arun Kaushik",
                               email: "",
                               password:              "",
                               password_confirmation: "" }
    end
    assert_template 'users/new'
  end

  test "should not create User | only name, email" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "Arun Kaushik",
                               email: "user@invalid",
                               password:              "",
                               password_confirmation: "" }
    end
    assert_template 'users/new'
  end

  test "should not create User | no password_confirmation" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "Arun Kaushik",
                               email: "user@invalid",
                               password:              "foobar",
                               password_confirmation: "" }
    end
    assert_template 'users/new'
  end

  test "should not create User | password_confirmation doesnt match" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "Arun Kaushik",
                               email: "user@invalid",
                               password:              "foobar",
                               password_confirmation: "foo" }
    end
    assert_template 'users/new'
  end

  test "should create a User" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Arun Kaushik",
                               email: "user@valid.com",
                               password:              "foobar",
                               password_confirmation: "foobar" }
    end
    # assert_template 'users/show'
    # assert is_logged_in?
  end


end
