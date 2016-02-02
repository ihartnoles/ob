class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_signup.subject
  #
  def email_signup(cust_name, cust_email)
    # @greeting = "Hi"

    # mail to: "to@example.org"
    @subject    = 'Welcome'
    @body       = "Welcome #{cust_name},\n\n Thank you for registering!\n\nUse your email address (#{cust_email}) and password to log in."
    @recipients = cust_email
    @from       = "noreply@fau.edu"
    @sent_on    = Time.now
    mail(:from => "ihartstein@fau.edu", :to => "ihartstein@fau.edu", :subject => "#{@subject}", :body => "#{@body}" )
  end
end
