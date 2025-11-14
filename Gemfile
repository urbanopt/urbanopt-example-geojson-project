source 'http://rubygems.org'

ruby '3.2.2'
gem 'rake', '~> 13.0' #, require: false, group: :test
gem 'rspec', '~> 3.9' #, require: false, group: :test
gem 'rubocop', '~> 1.50', require: false, group: :test
gem 'simplecov', '~> 0.22.0', require: false, group: :test
gem 'simplecov-lcov', '~> 0.8.0', require: false, group: :test
# can we comment this out?
# gem 'oga' # Required to be unversioned to match OpenStudio so residential will work :(

# Local gems are useful when developing and integrating the various dependencies.
# To favor the use of local gems, set the following environment variable:
#   Mac: export FAVOR_LOCAL_GEMS=1
#   Windows: set FAVOR_LOCAL_GEMS=1
# Note that if allow_local is true, but the gem is not found locally, then it will
# checkout the latest version (develop) from github.
# allow_local = ENV['FAVOR_LOCAL_GEMS']
allow_local = false

# Uncomment the extension, core gems if you need to test local development versions. Otherwise
# these are included in the model articulation and urbanopt gems
#
# if allow_local && File.exist?('../OpenStudio-extension-gem')
#   gem 'openstudio-extension', path: '../OpenStudio-extension-gem'
# elsif allow_local
# gem 'openstudio-extension', github: 'NREL/openstudio-extension-gem', branch: 'bundler-hack'
# else
gem 'openstudio-extension', '~> 0.9.4'
# end

# if allow_local && File.exist?('../openstudio-common-measures-gem')
#   gem 'openstudio-common-measures', path: '../openstudio-common-measures-gem'
# elsif allow_local
  # gem 'openstudio-common-measures', github: 'NREL/openstudio-common-measures-gem', branch: 'faraday'
# else
  gem 'openstudio-common-measures', '~> 0.12.3'
# end

# if allow_local && File.exist?('../openstudio-model-articulation-gem')
#   gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
# elsif allow_local
  # gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'faraday'
# else
  gem 'openstudio-model-articulation', '~> 0.12.2'
# end

# if allow_local && File.exist?('../openstudio-load-flexibility-measures-gem')
#   gem 'openstudio-load-flexibility-measures', path: '../openstudio-load-flexibility-measures-gem'
# elsif allow_local
  # gem 'openstudio-load-flexibility-measures', github: 'NREL/openstudio-load-flexibility-measures-gem', branch: 'faraday'
# else
  gem 'openstudio-load-flexibility-measures', '~> 0.11.1'
# end

# if allow_local && File.exist?('../openstudio-ee-gem')
#   gem 'openstudio-ee', path: '../opesntudio-ee-gem'
# elsif allow_local
  # gem 'openstudio-ee', github: 'NREL/openstudio-ee-gem', branch: 'faraday'
# else
  gem 'openstudio-ee', '~> 0.12.5'
# end

# if allow_local && File.exist?('../openstudio-calibration-gem')
#   gem 'openstudio-calibration', path: '../openstudio-calibration-gem'
# elsif allow_local
  # gem 'openstudio-calibration', github: 'NREL/openstudio-calibration-gem', branch: 'faraday'
# else
  gem 'openstudio-calibration', '~> 0.12.2'
# end

# if allow_local && File.exist?('../openstudio-geb-gem')
#   gem 'openstudio-geb', path: '../openstudio-geb-gem'
# elsif allow_local
# gem 'openstudio-geb', github: 'LBNL-ETA/openstudio-geb-gem', branch: 'faraday'
# else
gem 'openstudio-geb', '~> 0.7.0'
# end

# if allow_local && File.exist?('../urbanopt-core-gem')
#  gem 'urbanopt-core', path: '../urbanopt-core-gem'
# elsif allow_local
# TODO: Temporary! No need to require core-gem here once is merged/released
# gem 'urbanopt-core', github: 'URBANopt/urbanopt-core-gem', branch: 'faraday'
# else
   gem 'urbanopt-core', '~> 1.1.0'
# end

# if allow_local && File.exist?('../urbanopt-scenario-gem')
#   gem 'urbanopt-scenario', path: '../urbanopt-scenario-gem'
# elsif allow_local
#gem 'urbanopt-scenario', github: 'URBANopt/urbanopt-scenario-gem', branch: 'faraday'
# else
   gem 'urbanopt-scenario', '~> 1.1.0'
# end



# if allow_local && File.exist?('../urbanopt-geojson-gem')
#  gem 'urbanopt-geojson', path: '../urbanopt-geojson-gem'
# elsif allow_local
# gem 'urbanopt-geojson', github: 'URBANopt/urbanopt-geojson-gem', branch: 'faraday'
# else
  gem 'urbanopt-geojson', '~> 1.1.0'
# end

# if allow_local && File.exist?('../urbanopt-reopt-gem')
#   gem 'urbanopt-reopt', path: '../urbanopt-reopt-gem'
# elsif allow_local
# gem 'urbanopt-reopt', github: 'URBANopt/urbanopt-reopt-gem', branch: 'faraday'
# else
  gem 'urbanopt-reopt', '1.1.0'
# end

# if allow_local && File.exist?('../urbanopt-reporting-gem')
#   gem 'urbanopt-reporting', path: '../urbanopt-reporting-gem'
# elsif allow_local
# gem 'urbanopt-reporting', github: 'URBANopt/urbanopt-reporting-gem', branch: 'faraday'
# else
  gem 'urbanopt-reporting', '~> 1.1.0'
# end

# if allow_local && File.exist?('../urbanopt-rnm-us')
#   gem 'urbanopt-rnm-us', path: '../urbanopt/urbanopt-rnm-us-gem'
# elsif allow_local
# gem 'urbanopt-rnm-us', github: 'URBANopt/urbanopt-rnm-us-gem', branch: 'faraday'
# else
  gem 'urbanopt-rnm-us', '~> 1.1.0'
# end
