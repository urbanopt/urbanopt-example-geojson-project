source 'http://rubygems.org'

ruby '~> 2.7.0'

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
  gem 'urbanopt-scenario', '~> 0.6.0'
end

if allow_local && File.exist?('../urbanopt-reporting-gem')
  gem 'urbanopt-reporting', path: '../urbanopt-reporting-gem'
elsif allow_local
  gem 'urbanopt-reporting', github: 'URBANopt/urbanopt-reporting-gem', branch: 'develop'
else
  gem 'urbanopt-reporting', '~> 0.4.0'
end

if allow_local && File.exist?('../urbanopt-geojson-gem')
  gem 'urbanopt-geojson', path: '../urbanopt-geojson-gem'
elsif allow_local
  gem 'urbanopt-geojson', github: 'URBANopt/urbanopt-geojson-gem', branch: 'develop'
else
<<<<<<< HEAD
  gem 'urbanopt-geojson', '~> 0.6.1'
=======
  gem 'urbanopt-geojson', '~> 0.6.0'
>>>>>>> 0c57dba78c0ff54f1be4b761d65f5de42090924b
end

if allow_local && File.exist?('../urbanopt-reopt-gem')
  gem 'urbanopt-reopt', path: '../urbanopt-reopt-gem'
elsif allow_local
  gem 'urbanopt-reopt', github: 'URBANopt/urbanopt-reopt-gem', branch: 'develop'
else
  gem 'urbanopt-reopt', '0.6.0'
<<<<<<< HEAD
end
=======
end
>>>>>>> 0c57dba78c0ff54f1be4b761d65f5de42090924b
