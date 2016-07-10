ActionMailer::Base.smtp_settings = {
  :address => "smtp.mailgun.com",
  :port => 587,
  :user_name => "postmaster@sandboxa10801c2165642e4a2ddb007eef695f4.mailgun.org",
  :password => "84f61ed80eaeac322176648fc00a492f",
  :enable_starttls_auto => true,
  :openssl_verify_mode => "none"
}