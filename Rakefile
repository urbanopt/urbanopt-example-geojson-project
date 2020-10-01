#*********************************************************************************
# URBANopt™, Copyright (c) 2019-2020, Alliance for Sustainable Energy, LLC, and other
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
  scenario = File.basename(csv, '.csv')
  run_dir = File.join(root_dir, "run/#{scenario}/")
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

def visualize_scenarios
  name = 'Visualize Scenario Results'
  run_dir = File.join(root_dir, 'run')
  scenario_folder_dirs = []
  scenario_report_exists = false
  Dir.glob(File.join(run_dir, '/*_scenario')) do |scenario_folder_dir|
    scenario_report = File.join(scenario_folder_dir, 'default_scenario_report.csv')
    if File.exist?(scenario_report)
      scenario_folder_dirs << scenario_folder_dir
      scenario_report_exists = true
    else
      puts "\nERROR: Default reports not created for #{scenario_folder_dir}. Please use post processing command to create default post processing reports for all scenarios first. Visualization not generated for #{scenario_folder_dir}.\n"
    end
  end

  if scenario_report_exists == true
    puts "\nCreating visualizations for all Scenario results\n"
    URBANopt::Scenario::ResultVisualization.create_visualization(scenario_folder_dirs, false)
    vis_file_path = File.join(root_dir, 'visualization')
    if !File.exists?(vis_file_path)
      Dir.mkdir File.join(root_dir, 'visualization')
    end
    html_in_path = File.join(vis_file_path, 'input_visualization_scenario.html')
    if !File.exists?(html_in_path)
      visualization_file = 'https://raw.githubusercontent.com/urbanopt/urbanopt-example-geojson-project/master/example-project/visualization/input_visualization_scenario.html'
      vis_file_name = File.basename(visualization_file)
      vis_download = open(visualization_file, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
      IO.copy_stream(vis_download, File.join(vis_file_path, vis_file_name))
    end
    html_out_path = File.join(root_dir, 'run', 'scenario_comparison.html')
    FileUtils.cp(html_in_path, html_out_path)
    puts "\nDone\n"
  end
end

def visualize_features(scenario_file)
  name = 'Visualize Feature Results'
  scenario_name = File.basename(scenario_file, File.extname(scenario_file))
  run_dir = File.join(root_dir, 'run', scenario_name.downcase)
  feature_report_exists = false
  feature_id = CSV.read(File.join(root_dir, scenario_file), :headers => true)
  feature_folders = []
  # loop through building feature ids from scenario csv
  feature_id["Feature Id"].each do |feature|
    feature_report = File.join(run_dir, feature, 'feature_reports')
    if File.exist?(feature_report)
      feature_report_exists = true
      feature_folders << File.join(run_dir, feature)
    else
      puts "\nERROR: Default reports not created for #{feature}. Please use post processing command to create default post processing reports for all features first. Visualization not generated for #{feature}.\n"
    end
  end
  if feature_report_exists == true
    puts "\nCreating visualizations for Feature results in the Scenario\n"
    URBANopt::Scenario::ResultVisualization.create_visualization(feature_folders, true)
    vis_file_path = File.join(root_dir, 'visualization')
    if !File.exists?(vis_file_path)
      Dir.mkdir File.join(root_dir, 'visualization')
    end
    html_in_path = File.join(vis_file_path, 'input_visualization_feature.html')
    if !File.exists?(html_in_path)
      visualization_file = 'https://raw.githubusercontent.com/urbanopt/urbanopt-example-geojson-project/master/example_project/visualization/input_visualization_feature.html'
      vis_file_name = File.basename(visualization_file)
      vis_download = open(visualization_file, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
      IO.copy_stream(vis_download, File.join(vis_file_path, vis_file_name))
    end
    html_out_path = File.join(root_dir, 'run', scenario_name, 'feature_comparison.html')
    FileUtils.cp(html_in_path, html_out_path)
    puts "\nDone\n"
  end
end

# Load in the rake tasks from the base extension gem
rake_task = OpenStudio::Extension::RakeTask.new
rake_task.set_extension_class(URBANopt::ExampleGeoJSONProject::ExampleGeoJSONProject)

### Baseline

desc 'Clear Baseline Scenario'
task :clear_baseline, [:json, :csv] do |t, args|
  puts 'Clearing Baseline Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'baseline_scenario.csv' if csv.nil?

  baseline_scenario(json, csv).clear
end

desc 'Run Baseline Scenario'
task :run_baseline, [:json, :csv] do |t, args|
  puts 'Running Baseline Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'baseline_scenario.csv' if csv.nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(baseline_scenario(json, csv))
end

desc 'Post Process Baseline Scenario'
task :post_process_baseline, [:json, :csv] do |t, args|
  puts 'Post Processing Baseline Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'baseline_scenario.csv' if csv.nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(baseline_scenario(json, csv))
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

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'high_efficiency_scenario.csv' if csv.nil?

  high_efficiency_scenario(json, csv).clear
end

desc 'Run High Efficiency Scenario'
task :run_high_efficiency, [:json, :csv] do |t, args|
  puts 'Running High Efficiency Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'high_efficiency_scenario.csv' if csv.nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(high_efficiency_scenario(json, csv))
end

desc 'Post Process High Efficiency Scenario'
task :post_process_high_efficiency, [:json, :csv] do |t, args|
  puts 'Post Processing High Efficiency Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'high_efficiency_scenario.csv' if csv.nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(high_efficiency_scenario(json, csv))
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

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'thermal_storage_scenario.csv' if csv.nil?

  thermal_storage_scenario(json, csv).clear
end

desc 'Run Thermal Storage Scenario'
task :run_thermal_storage, [:json, :csv] do |t, args|
  puts 'Running Thermal Storage Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'thermal_storage_scenario.csv' if csv.nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(thermal_storage_scenario(json, csv))
end

desc 'Post Process Thermal Storage Scenario'
task :post_process_thermal_storage, [:json, :csv] do |t, args|
  puts 'Post Processing Thermal Storage Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'thermal_storage_scenario.csv' if csv.nil?

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

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'mixed_scenario.csv' if csv.nil?

  mixed_scenario(json, csv).clear
end

desc 'Run Mixed Scenario'
task :run_mixed, [:json, :csv] do |t, args|
  puts 'Running Mixed Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'mixed_scenario.csv' if csv.nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(mixed_scenario(json, csv))
end

desc 'Post Process Mixed Scenario'
task :post_process_mixed, [:json, :csv] do |t, args|
  puts 'Post Processing Mixed Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'mixed_scenario.csv' if csv.nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(mixed_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each do |feature_report|
    feature_report.save_feature_report()
  end
end

### Visualize scenario results

desc 'Visualize and compare results for all Scenarios'
task :visualize_scenarios do
  puts 'Visualizing results for all Scenarios...'
  visualize_scenarios
end

## Visualize feature results 

desc 'Visualize and compare results for all Features in a Scenario'
task :visualize_features, [:scenario_file] do |t, args|
  puts 'Visualizing results for all Features in the Scenario...'
  
  scenario_file = 'baseline_scenario.csv' if args[:scenario_file].nil?
  
  visualize_features(scenario_file)
end

### All

desc 'Clear all scenarios'
task :clear_all => [:clear_baseline, :clear_high_efficiency, :clear_thermal_storage, :clear_mixed] do
  # clear all the scenarios
end

desc 'Run all scenarios'
task :run_all => [:run_baseline, :run_high_efficiency, :run_thermal_storage, :run_mixed] do
  # run all the scenarios
end

desc 'Post process all scenarios'
task :post_process_all => [:post_process_baseline, :post_process_high_efficiency, :post_process_thermal_storage, :post_process_mixed] do
  # post_process all the scenarios
end

desc 'Run and post process all scenarios'
task :update_all => [:run_all, :post_process_all] do
  # run and post_process all the scenarios
end

task :default => :update_all
