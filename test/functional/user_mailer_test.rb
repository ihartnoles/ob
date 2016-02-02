require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "email_signup" do
    mail = UserMailer.email_signup
    assert_equal "Email signup", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
