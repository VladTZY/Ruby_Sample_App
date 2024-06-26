require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "accout_activation" do
    user = users(:vlad)
    user.activation_token = User.new_token

    mail = UserMailer.accout_activation(user)

    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded 
  end

end
