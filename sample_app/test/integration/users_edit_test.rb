require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:vlad)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: {
      name: "",
      email: "vlad@g",
      password: "123",
      password_confirmation: "321"
    }}

    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    name = "Vlad Vlad"
    email = "vlad2@gmail.com"

    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    }}

    assert_not flash.empty?
    assert_redirected_to @user
    
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)

    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)

    name = "Foor bar"
    email = "foo@bar.com"

    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: ""
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
