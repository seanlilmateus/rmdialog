$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'rmdialog'
  ## Using cocoapods, coming soon!
  # app.pods do
  #   dependency 'QuickDialog'
  # end
  
  app.vendor_project('vendor/QuickDialog', :xcode,
      :target => 'QuickDialog',
      :headers_dir => 'quickdialog')
  app.frameworks += ['MapKit', 'CoreLocation']
  app.device_family = [:iphone]
  
end
