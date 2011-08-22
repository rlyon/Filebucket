# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Filebucket::Application.initialize!

Time::DATE_FORMATS[:default] = "%m/%d/%Y %l:%M%p"