# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-example-geojson-project/blob/develop/LICENSE.md
# *********************************************************************************

# frozen_string_literal: true

called_from_cli = true
begin
  OpenStudio.getOpenStudioCLI
rescue
  called_from_cli = false
end

if ENV['CI'] && !called_from_cli
  begin
    require 'simplecov'
    SimpleCov.coverage_dir(File.join(Dir.getwd, 'coverage'))
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
    SimpleCov.start
  rescue
  end
end

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/reporters/spec_reporter' # Needed when run via OS CLI
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # spec-like progress
