# config/initializers/smtp.rb
ActionMailer::Base.smtp_settings = {
  user_name: ENV['SENDGRID_API_KEY'],
  password: ENV['SENDGRID_API_KEY'],
  domain: 'cforgoodwebsite-production.herokuapp.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

