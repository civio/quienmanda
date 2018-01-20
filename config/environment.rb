# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Quienmanda::Application.initialize!

# Define Facebook App Id for Facebook Sharing Buttons
Rails.configuration.facebook_app_id = 1045903075441335
