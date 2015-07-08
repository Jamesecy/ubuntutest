Cenit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  # config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  
  #config.action_mailer.default_url_options = { :host => "127.0.0.1"}
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.smtp_settings = {
   # :address              => "smtp.gmail.com",
    #:port                 => 465,
    #:domain               => 'caoyun.com',
    #:user_name            =>"caoyunzhan@gmail.com",
   # :password             =>"C@3513622zcy",
    #:authentication       => 'plain',
    #:enable_starttls_auto => true  }

  config.action_mailer.default_url_options = { :host => "localhost:3000"}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address              => "localhost",
      :port                 => 1025     }
  
end

DOORKEEPER_APP_ID = ENV['DOORKEEPER_APP_ID']
DOORKEEPER_APP_SECRET = ENV['DOORKEEPER_APP_SECRET']
DOORKEEPER_APP_URL = ENV['DOORKEEPER_APP_URL']