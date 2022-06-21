# *********************************************************************************
# URBANopt™, Copyright (c) 2019-2022, Alliance for Sustainable Energy, LLC, and other
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
# *********************************************************************************

require 'openstudio/extension'
require 'openstudio/extension/rake_task'
require 'rubocop/rake_task'
require 'urbanopt/scenario'
require 'urbanopt/geojson'
require 'urbanopt/reopt'
require 'urbanopt/reopt_scenario'
require_relative 'developer_nrel_key'

RuboCop::RakeTask.new

module URBANopt
  module ExampleGeoJSONProject
    class ExampleGeoJSONProject < OpenStudio::Extension::Extension
      # number of datapoints(features) you want to run in parallel
      # based on the number of available processors on your local machine.
      # This does not seem to function, instead added line to code for runner.config file
      # OpenStudio::Extension::Extension::NUM_PARALLEL = 7

      # set MAX_DATAPOINTS
      OpenStudio::Extension::Extension::MAX_DATAPOINTS = 1000

      def initialize
        super
        @root_dir = File.absolute_path(File.join(File.dirname(__FILE__), 'example_project'))
      end

      # Return the absolute path of the measures or empty string if there is none, can be used when configuring OSWs
      def measures_dir
        ''
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

def flexible_hot_water_scenario(json, csv)
  name = 'Flexible Hot Water Scenario'
  run_dir = File.join(root_dir, 'run/flexiblehotwater_scenario/')
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

def reopt_scenario(json, csv)
  name = 'REopt Scenario'
  run_dir = File.join(root_dir, 'run/reopt_scenario/')
  feature_file_path = File.join(root_dir, json)
  csv_file = File.join(root_dir, csv)
  mapper_files_dir = File.join(root_dir, 'mappers/')
  reopt_files_dir = File.join(root_dir, 'reopt/')
  scenario_reopt_assumptions_file_name = 'base_assumptions.json'
  num_header_rows = 1

  feature_file = URBANopt::GeoJSON::GeoFile.from_file(feature_file_path)
  scenario = URBANopt::Scenario::REoptScenarioCSV.new(name, root_dir, run_dir, feature_file, mapper_files_dir, csv_file, num_header_rows, reopt_files_dir, scenario_reopt_assumptions_file_name)
  return scenario
end

def configure_project
  # write a runner.conf in project dir if it does not exist
  # delete runner.conf to automatically regenerate it
  options = { gemfile_path: File.join(root_dir, 'Gemfile'), bundle_install_path: File.join(root_dir, '.bundle/install'), num_parallel: 7 }

  # write a runner.conf in project dir (if it does not already exist)
  if !File.exist?(File.join(root_dir, 'runner.conf'))
    puts 'GENERATING runner.conf file'
    OpenStudio::Extension::RunnerConfig.init(root_dir) # itinialize the file with default values
    run_config = OpenStudio::Extension::RunnerConfig.new(root_dir) # get the configs
    # update paths
    options.each do |key, val|
      run_config.update_config(key, val) # update gemfile_path
    end
    # save back to disk
    run_config.save
  else
    puts 'USING existing runner.conf file'
  end
end

def visualize_scenarios
  name = 'Visualize Scenario Results'
  run_dir = File.join(root_dir, 'run')
  scenario_folders = []
  scenario_report_exists = false
  Dir.glob(File.join(run_dir, '/*_scenario')) do |scenario_folder|
    scenario_report = File.join(scenario_folder, 'scenario_optimization.csv')
    # Check if Scenario Optimization REopt file exists and add that
    if File.exist?(File.join(scenario_folder, 'scenario_optimization.csv'))
      scenario_folders << File.join(scenario_folder, 'scenario_optimization.csv')
      scenario_report_exists = true
    # Check if Default Feature Report exists and add that
    elsif File.exist?(File.join(scenario_folder, 'default_scenario_report.csv'))
      scenario_folders << File.join(scenario_folder, 'default_scenario_report.csv')
      scenario_report_exists = true
    else puts "\nERROR: Default reports not created for #{scenario_folder}. Please use 'process --default' to create default post processing reports for all scenarios first. Visualization not generated for #{scenario_folder}.\n"
    end
  end
  if scenario_report_exists == true
    puts "\nCreating visualizations for all Scenario results\n"
    URBANopt::Scenario::ResultVisualization.create_visualization(scenario_folders, false)
    vis_file_path = File.join(root_dir, 'visualization')
    if !File.exist?(vis_file_path)
      Dir.mkdir File.join(root_dir, 'visualization')
    end
    html_in_path = File.join(vis_file_path, 'input_visualization_scenario.html')
    if !File.exist?(html_in_path)
      $LOAD_PATH.each do |path_item|
        if path_item.to_s.end_with?('example_files')
          FileUtils.cp(File.join(path_item, 'visualization', 'input_visualization_scenario.html'), html_in_path)
        end
      end
    end
    html_out_path = File.join(run_dir, 'scenario_comparison.html')
    FileUtils.cp(html_in_path, html_out_path)
    puts "\nDone\n"
  end
end

def visualize_features(scenario_file)
  name = 'Visualize Feature Results'

  scenario_name = File.basename(scenario_file, File.extname(scenario_file))
  run_dir = File.join(root_dir, 'run', scenario_name.downcase)
  feature_report_exists = false
  csv = CSV.read(File.join(root_dir, scenario_file), headers: true)
  feature_names = csv['Feature Name']
  feature_folders = []
  # loop through building feature ids from scenario csv
  csv['Feature Id'].each do |feature|
    # Check if Feature Optimization REopt file exists and add that
    if File.exist?(File.join(run_dir, feature, 'feature_reports/feature_optimization.csv'))
      feature_report_exists = true
      feature_folders << File.join(run_dir, feature, 'feature_reports/feature_optimization.csv')
    elsif File.exist?(File.join(run_dir, feature, 'feature_reports/default_feature_report.csv'))
      feature_report_exists = true
      feature_folders << File.join(run_dir, feature, 'feature_reports/default_feature_report.csv')
    else puts "\nERROR: Default reports not created for #{feature}. Please use 'process --default' to create default post processing reports for all features first. Visualization not generated for #{feature}.\n"
    end
  end
  if feature_report_exists == true
    puts "\nCreating visualizations for Feature results in the Scenario\n"
    URBANopt::Scenario::ResultVisualization.create_visualization(feature_folders, true, feature_names)
    vis_file_path = File.join(root_dir, 'visualization')
    if !File.exist?(vis_file_path)
      Dir.mkdir File.join(root_dir, 'visualization')
    end
    html_in_path = File.join(vis_file_path, 'input_visualization_feature.html')
    if !File.exist?(html_in_path)
      $LOAD_PATH.each do |path_item|
        if path_item.to_s.end_with?('example_files')
          FileUtils.cp(File.join(path_item, 'visualization', 'input_visualization_feature.html'), html_in_path)
        end
      end
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
  scenario_result.feature_reports.each(&:save_json_report)
  scenario_result.feature_reports.each(&:save_csv_report)
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
  scenario_result.feature_reports.each(&:save_json_report)
  scenario_result.feature_reports.each(&:save_csv_report)
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
  scenario_result.feature_reports.each(&:save_json_report)
  scenario_result.feature_reports.each(&:save_csv_report)
end

### Flexible Hot Water

desc 'Clear Flexible Hot Water Scenario'
task :clear_flexible_hot_water, [:json, :csv] do |t, args|
  puts 'Clearing Flexible Hot Water Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'flexible_hot_water_scenario.csv' if csv.nil?

  flexible_hot_water_scenario(json, csv).clear
end

desc 'Run Flexible Hot Water Scenario'
task :run_flexible_hot_water, [:json, :csv] do |t, args|
  puts 'Running Flexible Hot Water Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'flexible_hot_water_scenario.csv' if csv.nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(flexible_hot_water_scenario(json, csv))
end

desc 'Post Process Flexible Hot Water Scenario'
task :post_process_flexible_hot_water, [:json, :csv] do |t, args|
  puts 'Post Processing Flexible Hot Water Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_combined.json' if json.nil?
  csv = 'flexible_hot_water_scenario.csv' if csv.nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(flexible_hot_water_scenario(json, csv))
  scenario_result = default_post_processor.run
  # save scenario reports
  scenario_result.save
  # save feature reports
  scenario_result.feature_reports.each(&:save_json_report)
  scenario_result.feature_reports.each(&:save_csv_report)
end

### REopt

desc 'Clear REopt Scenario'
task :clear_reopt, [:json, :csv] do |t, args|
  puts 'Clearing REopt Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_with_PV.json' if json.nil?
  csv = 'reopt_scenario.csv' if csv.nil?

  reopt_scenario(json, csv).clear
end

desc 'Run REopt Scenario'
task :run_reopt, [:json, :csv] do |t, args|
  puts 'Running REopt Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_with_PV.json' if json.nil?
  csv = 'reopt_scenario.csv' if csv.nil?

  configure_project

  scenario_runner = URBANopt::Scenario::ScenarioRunnerOSW.new
  scenario_runner.run(reopt_scenario(json, csv))
end

desc 'Post Process REopt Scenario'
task :post_process_reopt, [:json, :csv] do |t, args|
  puts 'Post Processing REopt Scenario...'

  json = args[:json]
  csv = args[:csv]
  json = 'example_project_with_PV.json' if json.nil?
  csv = 'reopt_scenario.csv' if csv.nil?

  default_post_processor = URBANopt::Scenario::ScenarioDefaultPostProcessor.new(reopt_scenario(json, csv))
  scenario_report = default_post_processor.run
  # save scenario reports
  scenario_report.save
  # save feature reports
  scenario_report.feature_reports.each(&:save_json_report)
  scenario_report.feature_reports.each(&:save_csv_report)

  scenario_base = default_post_processor.scenario_base
  reopt_post_processor = URBANopt::REopt::REoptPostProcessor.new(scenario_report, scenario_base.scenario_reopt_assumptions_file, scenario_base.reopt_feature_assumptions, DEVELOPER_NREL_KEY)

  community_photovoltaic = []
  groundmount_photovoltaic = {}
  feature_file = JSON.parse(File.read(File.join(root_dir, json)), symbolize_names: true)
  feature_file[:features].each do |feature|
    # Add community photovoltaic if present in the Feature File
    case feature[:properties][:district_system_type]
    when 'Community Photovoltaic'
      community_photovoltaic << feature
    # Add groundmount photovoltaic if present in the Feature File
    when 'Ground Mount Photovoltaic'
      groundmount_photovoltaic[feature[:properties][:associated_building_id]] = feature[:properties][:footprint_area]
    end
  rescue StandardError
  end

  # Run Aggregate Scenario
  scenario_report_scenario = reopt_post_processor.run_scenario_report(scenario_report: scenario_report, save_name: 'scenario_report_reopt_global_optimization', run_resilience: true, community_photovoltaic: community_photovoltaic)

  # Run features individually - this is an alternative approach to the previous step, in your analysis depending on project ojectives you maye only need to run one
  scenario_report_features = reopt_post_processor.run_scenario_report_features(scenario_report: scenario_report, save_names_feature_reports: ['feature_report_reopt'] * scenario_report.feature_reports.length, save_name_scenario_report: 'scenario_report_reopt_local_optimization', run_resilience: true,
                                                                               keep_existing_output: false, groundmount_photovoltaic: groundmount_photovoltaic)
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
  scenario_result.feature_reports.each(&:save_json_report)
  scenario_result.feature_reports.each(&:save_csv_report)
end

### Visualize scenario results

desc 'Visualize and compare results for all Scenarios'
task :visualize_scenarios do
  puts 'Visualizing results for all Scenarios...'
  visualize_scenarios
end

## Visualize feature results

desc 'Visualize and compare results for all Features in a Scenario'
task :visualize_features, [:csv] do |t, args|
  puts 'Visualizing results for all Features in the Scenario...'

  csv = args[:csv]
  csv = 'baseline_scenario.csv' if args[:csv].nil?

  visualize_features(csv)
end

### All

desc 'Clear all scenarios'
task clear_all: [:clear_baseline, :clear_high_efficiency, :clear_thermal_storage, :clear_flexible_hot_water, :clear_reopt, :clear_mixed] do
  # clear all the scenarios
end

desc 'Run all scenarios'
task run_all: [:run_baseline, :run_high_efficiency, :run_thermal_storage, :run_flexible_hot_water, :run_reopt, :run_mixed] do
  # run all the scenarios
end

desc 'Post process all scenarios'
task post_process_all: [:post_process_baseline, :post_process_high_efficiency, :post_process_thermal_storage, :post_process_flexible_hot_water, :post_process_reopt, :post_process_mixed] do
  # post_process all the scenarios
end

desc 'Visualize all scenarios'
task :visualize_all do
  # visualize all features within each scenario, then visualize across all scenarios
  Rake::Task['visualize_features'].invoke('baseline_scenario.csv')
  Rake::Task['visualize_features'].reenable
  Rake::Task['visualize_features'].invoke('high_efficiency_scenario.csv')
  Rake::Task['visualize_features'].reenable
  Rake::Task['visualize_features'].invoke('thermal_storage_scenario.csv')
  Rake::Task['visualize_features'].reenable
  Rake::Task['visualize_features'].invoke('flexible_hot_water_scenario.csv')
  Rake::Task['visualize_features'].reenable
  Rake::Task['visualize_features'].invoke('reopt_scenario.csv')
  Rake::Task['visualize_features'].reenable
  Rake::Task['visualize_features'].invoke('mixed_scenario.csv')
  Rake::Task['visualize_scenarios'].invoke
end

desc 'Run and post process all scenarios'
task update_all: [:run_all, :post_process_all, :visualize_all] do
  # run and post_process all the scenarios
end

task default: :update_all
