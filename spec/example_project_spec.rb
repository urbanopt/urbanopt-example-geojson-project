# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-example-geojson-project/blob/develop/LICENSE.md
# *********************************************************************************

require 'spec_helper'
require 'rake'

# example: https://stackoverflow.com/questions/6895179/running-rake-tasks-in-rspec-tests
load File.expand_path('../Rakefile', __dir__)

RSpec.describe URBANopt::ExampleGeoJSONProject do
  run_dir = File.expand_path(File.join(__dir__, '..', 'example_project', 'run'))

  it 'runs all rake tasks' do
    Rake::Task['run_all'].invoke

    # Every feature in every scenario should finish successfully, having a finished.job file
    Pathname(run_dir).children.each do |scenario|
      if File.directory?(scenario)
        Pathname(scenario).children.each do |feature|
          if File.directory?(feature)
            puts "Checking #{feature}"
            expect(File.exist?(File.join(feature, 'finished.job'))).to be true
          end
        end
      end
    end
  end

  it 'post-processes all rake tasks' do
    Rake::Task['post_process_all'].invoke

    Pathname(run_dir).children.each do |scenario|
      if File.directory?(scenario)
        expect(File.exist?(File.join(scenario, 'default_scenario_report.json'))).to be true
      end
    end
  end

  it 'checks visualization stdout for errors' do
    expect { Rake::Task['visualize_all'].invoke }
      .not_to output(a_string_including('Error'))
      .to_stdout_from_any_process
  end
end
