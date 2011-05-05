# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Filebox::Application.initialize!

Time::DATE_FORMATS[:default] = "%m/%d/%Y %l:%M%p"