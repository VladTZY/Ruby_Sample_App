require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:vlad)
  end

  test "login with valid information followed by logout" do
    # Login the user
    get login_path
    post login_path, params: {session: {
      email: @user.email,
      password: "testpass"
    }}

    # check if he logged in
    assert is_logged_in?

    # check redirect
    assert_redirected_to @user
    follow_redirect!
    
    # check logged in template
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", user_path(@user)

    #logout
    delete logout_path

    #check if logout is succesfull
    assert_not is_logged_in?
    
    # simulate a user clicking logout in second window
    delete logout_path

    #check if logout flow is good
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), count: 0

  end

  test "login with invalid information" do
    # try to log in
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: {
      email: "",
      password: ""
    }}

    # check to make sure login failed
    assert_not is_logged_in?

    #check if it rerendred
    assert_template 'sessions/new'
    assert_not flash.empty?

    # make sure the flash dissapres
    get root_path
    assert flash.empty?
  end


  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "login withour remembering" do
    #login 
    log_in_as(@user, remember_me: "1")

    #login again to make sure cookies get deleted
    log_in_as(@user, remember_me: "0")

    #assert_empty cookies[:remember_token]
  end
end
