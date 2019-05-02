source "http://rubygems.org"

allow_local = true

if allow_local && File.exists?('../OpenStudio-extension-gem')
  # gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
  gem 'openstudio-extension', path: '../OpenStudio-extension-gem'
else
  gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
end

if allow_local && File.exist?('../openstudio-common-measures-gem')
  # gem 'openstudio-common-measures', github: 'NREL/openstudio-common-measures-gem', branch: 'develop'
  gem 'openstudio-common-measures', path: '../openstudio-common-measures-gem'
else
  gem 'openstudio-common-measures', github: 'NREL/openstudio-common-measures-gem', branch: 'develop'
end

if allow_local && File.exist?('../openstudio-model-articulation-gem')
  # gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'develop'
  gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
else
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'develop'
end

if allow_local && File.exist?('../urbanopt-core-gem')
  # gem 'urbanopt-core', github: 'URBANopt/urbanopt-core-gem', branch: 'develop'
  gem 'urbanopt-core', path: '../urbanopt-core-gem'
else
  gem 'urbanopt-core', github: 'URBANopt/urbanopt-core-gem', branch: 'develop'
end

if allow_local && File.exist?('../urbanopt-scenario-gem')
  # gem 'urbanopt-scenario', github: 'URBANopt/urbanopt-scenario-gem', branch: 'develop'
  gem 'urbanopt-scenario', path: '../urbanopt-scenario-gem'
else
  gem 'urbanopt-scenario', github: 'URBANopt/urbanopt-scenario-gem', branch: 'develop'
end

if allow_local && File.exists?('../urbanopt-geojson-gem')
  # gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
  gem 'urbanopt-geojson', path: '../urbanopt-geojson-gem'
else
  gem 'urbanopt-geojson', github: 'urbanopt/urbanopt-geojson-gem', branch: 'method-extractions'
end

gem 'openstudio-standards', '0.2.9' # doesn't work in 0.2.8?

# simplecov has an unneccesary dependency on native json gem, use fork that does not require this
gem 'simplecov', github: 'NREL/simplecov'