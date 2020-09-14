#*********************************************************************************
# URBANopt, Copyright (c) 2019-2020, Alliance for Sustainable Energy, LLC, and other
# contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or other
# materials provided with the distribution.
#
# Neither the name of the copyright holder nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#*********************************************************************************

require 'openstudio/extension'
require 'openstudio/extension/rake_task'
require 'urbanopt/scenario'
require 'urbanopt/geojson'

module URBANopt
  module ExampleGeoJSONProject
    class ExampleGeoJSONProject < OpenStudio::Extension::Extension

      # number of datapoints(features) you want to run in parallel
      # based on the number of available processors on your local machine.
      OpenStudio::Extension::Extension::NUM_PARALLEL = 7

      # set MAX_DATAPOINTS
      OpenStudio::Extension::Extension::MAX_DATAPOINTS = 1000

      def initialize
        super
        @root_dir = File.absolute_path(File.join(File.dirname(__FILE__), 'example_project'))
      end

      # Return the absolute path of the measures or empty string if there is none, can be used when configuring OSWs
      def measures_dir
        ""
      end

      # Relevant files such as weather data, design days, etc.
      # Return the absolute path of the files or nil if there is none, used when configuring OSWs
      def files_dir
        return File.absolute_path(File.join(@root_dir, 'weather'))
      end

    end
  end
end

def root_dir
  return File.join(File.dirname(__FILE__), 'example_project')
end

def baseline_scenario(json, csv)
  name = 'Baseline Scenario'
  run_dir = File.join(root_dir, 'run/baseline_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')

  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def baseline_createbar(json, csv)
  name = 'Baseline Create Bar Scenario'
  run_dir = File.join(root_dir, 'run/createbar_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')

  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def baseline_floorspace(json, csv)
  name = 'Baseline Floorspace Scenario'
  run_dir = File.join(root_dir, 'run/floorspace_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')

  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def high_efficiency_scenario(json, csv)
  name = 'High Efficiency Scenario'

  run_dir = File.join(root_dir, 'run/high_efficiency_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def high_efficiency_createbar_scenario(json, csv)
  name = 'High Efficiency Create Bar Scenario'

  run_dir = File.join(root_dir, 'run/highefficiencycreatebar_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def high_efficiency_floorspace_scenario(json, csv)
  name = 'High Efficiency Floorspace Scenario'

  run_dir = File.join(root_dir, 'run/highefficiencyfloorspace_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def thermal_storage_scenario(json, csv)
  name = 'Thermal Storage Scenario'
  run_dir = File.join(root_dir, 'run/thermal_storage_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def mixed_scenario(json, csv)
  name = 'Mixed Scenario'
  run_dir = File.join(root_dir, 'run/mixed_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::ScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows)
  return scenario
end

def configure_project
  # write a runner.conf in project dir
  options = {gemfile_path: File.join(root_dir, 'Gemfile'), bundle_install_path: File.join(root_dir, ".bundle/install")}
  File.open(File.join(root_dir, 'runner.conf'), "w") do |f|
    f.write(options.to_json)
  end
end

# Load in the rake tasks from the base extension gem
rake_task = OpenStudio::Extension::RakeTask.new
rake_task.set_extension_class(URBANopt::ExampleGeoJSONProject::ExampleGeoJSONProject)

### Baseline

desc 'Clear Baseline Scenario'
task :clear_baseline, [:json, :csv] do |t, args|
  puts 'Clearing Baseline Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'baseline_scenario.csv' if args[:csv].nil?

  baseline_scenario(json, csv).clear
end

desc 'Run Baseline Scenario'
task :run_baseline, [:json, :csv] do |t, args|
  puts 'Running Baseline Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'baseline_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(baseline_scenario(json, csv))
end

desc 'Post Process Baseline Scenario'
task :post_process_baseline, [:json, :csv] do |t, args|
  puts 'Post Processing Baseline Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'baseline_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(baseline_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### Create Bar Baseline

desc 'Clear Baseline Create Bar Scenario'
task :clear_createbar, [:json, :csv] do |t, args|
  puts 'Clearing Create Bar Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'createbar_scenario.csv' if args[:csv].nil?

  baseline_createbar(json, csv).clear
end

desc 'Run Baseline Project using Create Bar Geometry Method'
task :run_createbar, [:json, :csv] do |t, args|
  puts 'Running Baseline Project Using Create Bar Geometry Method'

  json = 'example_project.json' if args[:json].nil?
  csv = 'createbar_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(baseline_createbar(json, csv))
end

desc 'Post Process Baseline Project using Create Bar Geometry Method'
task :post_process_createbar, [:json, :csv] do |t, args|
  puts 'Post Processing Baseline Project using Create Bar Geometry Method...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'createbar_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(baseline_createbar(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### Floorspace Baseline

desc 'Clear Baseline Floorspace Scenario'
task :clear_floorspace, [:json, :csv] do |t, args|
  puts 'Clearing Floorspace Scenario...'

  json = 'example_floorspace_project.json' if args[:json].nil?
  csv = 'floorspace_scenario.csv' if args[:csv].nil?

  baseline_floorspace(json, csv).clear
end

desc 'Run Baseline Project using Floorspace Geometry Method'
task :run_floorspace, [:json, :csv] do |t, args|
  puts 'Running Baseline Project Using Floorspace Method'

  json = 'example_floorspace_project.json' if args[:json].nil?
  csv = 'floorspace_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(baseline_floorspace(json, csv))
end

desc 'Post Process Baseline Project using Floorspace Geometry Method'
task :post_process_floorspace, [:json, :csv] do |t, args|
  puts 'Post Processing Baseline Project Using Floorspace Methods...'

  json = 'example_floorspace_project.json' if args[:json].nil?
  csv = 'floorspace_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(baseline_floorspace(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### High Efficiency

desc 'Clear High Efficiency Scenario'
task :clear_high_efficiency, [:json, :csv] do |t, args|
  puts 'Clearing High Efficiency Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'high_efficiency_scenario.csv' if args[:csv].nil?

  high_efficiency_scenario(json, csv).clear
end

desc 'Run High Efficiency Scenario'
task :run_high_efficiency, [:json, :csv] do |t, args|
  puts 'Running High Efficiency Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'high_efficiency_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(high_efficiency_scenario(json, csv))
end

desc 'Post Process High Efficiency Scenario'
task :post_process_high_efficiency, [:json, :csv] do |t, args|
  puts 'Post Processing High Efficiency Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'high_efficiency_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(high_efficiency_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### High Efficiency Createbar

desc 'Clear High Efficiency  Create Bar Scenario'
task :clear_high_efficiency_createbar, [:json, :csv] do |t, args|
  puts 'Clearing High Efficiency Create Bar Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'highefficiencycreatebar_scenario.csv' if args[:csv].nil?

  high_efficiency_createbar_scenario(json, csv).clear
end

desc 'Run High Efficiency Create Bar Scenario'
task :run_high_efficiency_createbar, [:json, :csv] do |t, args|
  puts 'Running High Efficiency Scenario for Create Bar Geometry method...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'highefficiencycreatebar_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(high_efficiency_createbar_scenario(json, csv))
end

desc 'Post Process High Efficiency Create Bar Scenario'
task :post_process_high_efficiency_createbar, [:json, :csv] do |t, args|
  puts 'Post Processing High Efficiency Scenario for Create Bar Geometry method...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'highefficiencycreatebar_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(high_efficiency_createbar_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### High Efficiency Floorspace

desc 'Clear High Efficiency Floorspace Scenario'
task :clear_high_efficiency_floorspace, [:json, :csv] do |t, args|
  puts 'Clearing High Efficiency Floorspace Scenario...'

  json = 'example_floorspace_project.json' if args[:json].nil?
  csv = 'highefficiencyfloorspace_scenario.csv' if args[:csv].nil?

  high_efficiency_floorspace_scenario(json, csv).clear
end

desc 'Run High Efficiency Floorspace Scenario'
task :run_high_efficiency_floorspace, [:json, :csv] do |t, args|
  puts 'Running High Efficiency Scenario for Floorspace Geometry method...'

  json = 'example_floorspace_project.json' if args[:json].nil?
  csv = 'highefficiencyfloorspace_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(high_efficiency_floorspace_scenario(json, csv))
end

desc 'Post Process High Efficiency Floorspace Scenario'
task :post_process_high_efficiency_floorspace, [:json, :csv] do |t, args|
  puts 'Post Processing High Efficiency for Floorspace Geometry method...'

  json = 'example_floorspace_project.json' if args[:json].nil?
  csv = 'highefficiencyfloorspace_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(high_efficiency_floorspace_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### Thermal Storage

desc 'Clear Thermal Storage Scenario'
task :clear_thermal_storage, [:json, :csv] do |t, args|
  puts 'Clearing Thermal Storage Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'thermal_storage_scenario.csv' if args[:csv].nil?

  thermal_storage_scenario(json, csv).clear
end

desc 'Run Thermal Storage Scenario'
task :run_thermal_storage, [:json, :csv] do |t, args|
  puts 'Running Thermal Storage Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'thermal_storage_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(thermal_storage_scenario(json, csv))
end

desc 'Post Process Thermal Storage Scenario'
task :post_process_thermal_storage, [:json, :csv] do |t, args|
  puts 'Post Processing Thermal Storage Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'thermal_storage_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(thermal_storage_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### Mixed

desc 'Clear Mixed Scenario'
task :clear_mixed, [:json, :csv] do |t, args|
  puts 'Clearing Mixed Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'mixed_scenario.csv' if args[:csv].nil?

  mixed_scenario(json, csv).clear
end

desc 'Run Mixed Scenario'
task :run_mixed, [:json, :csv] do |t, args|
  puts 'Running Mixed Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'mixed_scenario.csv' if args[:csv].nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(mixed_scenario(json, csv))
end

desc 'Post Process Mixed Scenario'
task :post_process_mixed, [:json, :csv] do |t, args|
  puts 'Post Processing Mixed Scenario...'

  json = 'example_project.json' if args[:json].nil?
  csv = 'mixed_scenario.csv' if args[:csv].nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(mixed_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### All

desc 'Clear all scenarios'
task :clear_all => [:clear_baseline, :clear_createbar, :clear_floorspace, :clear_high_efficiency, :clear_high_efficiency_createbar, :clear_high_efficiency_floorspace, :clear_thermal_storage, :clear_mixed] do
  # clear all the scenarios
end

desc 'Run all scenarios'
task :run_all => [:run_baseline, :run_createbar, :run_floorspace, :run_high_efficiency, :run_high_efficiency_createbar, :run_high_efficiency_floorspace, :run_thermal_storage, :run_mixed] do
  # run all the scenarios
end

desc 'Post process all scenarios'
task :post_process_all => [:post_process_baseline, :post_process_createbar, :post_process_floorspace, :post_process_high_efficiency, :post_process_high_efficiency_createbar, :post_process_high_efficiency_floorspace, :post_process_thermal_storage, :post_process_mixed] do
  # post_process all the scenarios
end

desc 'Run and post process all scenarios'
task :update_all => [:run_all, :post_process_all] do
  # run and post_process all the scenarios
end

task :default => :update_all
