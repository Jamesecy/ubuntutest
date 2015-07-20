# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  config.site_name = "Spree Demo Hub included"
  config.allow_ssl_in_production = false
end

Spree.user_class = "Spree::User"

# Spree::Hub::Config[:hub_store_id] = ENV["HUB_STORE_ID"]
# Spree::Hub::Config[:hub_token] = ENV["HUB_TOKEN"]
# Spree::Hub::Config[:enable_push] = true
# Spree::Hub::Config[:enable_auto_push] = true
# Spree::Hub::Config[:hub_push_uri] = "https://push.wombat.co"
