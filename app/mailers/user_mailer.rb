class UserMailer < ActionMailer::Base
  default from: "noreply@fau.edu"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_signup.subject
  #
  def email_signup(cust_name, cust_email)
    @subject    = 'Get Owl Done! - Another Test'
    @body       = "Welcome #{cust_name},\n\n Thank you for registering!\n\nUse your email address and password to log in."
    @recipients = cust_email
    @from       = "noreply@fau.edu"
    @sent_on    = Time.now
    mail(:from => "noreply@fau.edu", :to => "#{cust_email}", :cc => "ihartstein@fau.edu", :subject => "#{@subject}" )
 end
end
