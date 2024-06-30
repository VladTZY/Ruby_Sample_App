require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user =  User.new(name: "Example user", email: "user@example.com",
                      password: "testpass", password_confirmation: "testpass")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a' * 254 + "example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com User@foo.COM A_US-Er@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com
                            vlad@ex..com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "emails shouldn't be saved with uppercases" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end 

  test "authenticated? should  return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")

    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    vlad = users(:vlad)
    mihai = users(:mihai)

    assert_not vlad.following?(mihai)

    vlad.follow(mihai)

    assert vlad.following?(mihai)
    assert mihai.followers.include?(vlad)

    vlad.unfollow(mihai)

    assert_not vlad.following?(mihai)
  end

  test "feed should have the right posts" do
    vlad = users(:vlad)
    mihai = users(:mihai)
    maria = users(:maria)

    #debugger
    # posts from self
    vlad.microposts.each do |post_self|
      assert vlad.feed.include?(post_self)
    end

    # post from followed user
    maria.microposts.each do |post_following|
      assert vlad.feed.include?(post_following)
    end

    # post from unfollowed user
    mihai.microposts.each do |post_unfollowed|
      assert_not vlad.feed.include?(post_unfollowed)
    end
  end
end
