source 'https://rubygems.org'

ruby '~> 2.7.0'
gem 'rspec', '>= 3.9'
gem 'rubocop', '~> 1.15.0', require: false
gem 'rubocop-checkstyle_formatter', '~> 0.4.0'
gem 'rubocop-performance', '~> 1.11.3'
gem 'coveralls'
# gem 'coveralls-lcov', '~> 1.7.0'
gem 'simplecov', '~> 0.18.2', require: false, group: :test
gem 'simplecov-lcov'

# Local gems are useful when developing and integrating the various dependencies.
# To favor the use of local gems, set the following environment variable:
#   Mac: export FAVOR_LOCAL_GEMS=1
#   Windows: set FAVOR_LOCAL_GEMS=1
# Note that if allow_local is true, but the gem is not found locally, then it will
# checkout the latest version (develop) from github.
allow_local = ENV['FAVOR_LOCAL_GEMS']

# Uncomment the extension, core gems if you need to test local development versions. Otherwise
# these are included in the model articulation and urbanopt gems
#
# if allow_local && File.exist?('../OpenStudio-extension-gem')
#   gem 'openstudio-extension', path: '../OpenStudio-extension-gem'
# elsif allow_local
#   gem 'openstudio-extension', github: 'NREL/openstudio-extension-gem', branch: 'develop'
# end

if allow_local && File.exist?('../openstudio-common-measures-gem')
 gem 'openstudio-common-measures', path: '../openstudio-common-measures-gem'
elsif allow_local
gem 'openstudio-common-measures', github: 'NREL/openstudio-common-measures-gem', branch: 'develop'
else
 gem 'openstudio-common-measures', '~> 0.6.1'
end

if allow_local && File.exist?('../openstudio-model-articulation-gem')
  gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
elsif allow_local
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'develop'
else
  gem 'openstudio-model-articulation', '~> 0.6.1'
end

if allow_local && File.exist?('../openstudio-load-flexibility-measures-gem')
  gem 'openstudio-load-flexibility-measures', path: '../openstudio-load-flexibility-measures-gem'
elsif allow_local
  gem 'openstudio-load-flexibility-measures', github: 'NREL/openstudio-load-flexibility-measures-gem', branch: 'master'
else
  gem 'openstudio-load-flexibility-measures', '~> 0.5.0'
end

if allow_local && File.exist?('../openstudio-ee-gem')
  gem 'openstudio-ee', path: '../opesntudio-ee-gem'
elsif allow_local
  gem 'openstudio-ee', github: 'NREL/openstudio-ee-gem', branch: 'develop'
else
  gem 'openstudio-ee', '~> 0.6.0'
end

if allow_local && File.exist?('../openstudio-calibration-gem')
  gem 'openstudio-calibration', path: '../openstudio-calibration-gem'
elsif allow_local
  gem 'openstudio-calibration', github: 'NREL/openstudio-calibration-gem', branch: 'develop'
else
  gem 'openstudio-calibration', '~> 0.6.0'
end

# if allow_local && File.exist?('../urbanopt-core-gem')
#   gem 'urbanopt-core', path: '../urbanopt-core-gem'
# elsif allow_local
#   gem 'urbanopt-core', github: 'URBANopt/urbanopt-core-gem', branch: 'develop'
# end

if allow_local && File.exist?('../urbanopt-scenario-gem')
  gem 'urbanopt-scenario', path: '../urbanopt-scenario-gem'
elsif allow_local
  gem 'urbanopt-scenario', github: 'URBANopt/urbanopt-scenario-gem', branch: 'develop'
else
  gem 'urbanopt-scenario', '~> 0.8.0'
end

if allow_local && File.exist?('../urbanopt-reporting-gem')
  gem 'urbanopt-reporting', path: '../urbanopt-reporting-gem'
elsif allow_local
  gem 'urbanopt-reporting', github: 'URBANopt/urbanopt-reporting-gem', branch: 'develop'
else
  gem 'urbanopt-reporting', '~> 0.6.1'
end

if allow_local && File.exist?('../urbanopt-geojson-gem')
  gem 'urbanopt-geojson', path: '../urbanopt-geojson-gem'
elsif allow_local
  gem 'urbanopt-geojson', github: 'URBANopt/urbanopt-geojson-gem', branch: 'develop'
else
  gem 'urbanopt-geojson', '~> 0.8.1'
end

if allow_local && File.exist?('../urbanopt-reopt-gem')
  gem 'urbanopt-reopt', path: '../urbanopt-reopt-gem'
elsif allow_local
  gem 'urbanopt-reopt', github: 'URBANopt/urbanopt-reopt-gem', branch: 'develop'
else
  gem 'urbanopt-reopt', '0.8.0'
end
