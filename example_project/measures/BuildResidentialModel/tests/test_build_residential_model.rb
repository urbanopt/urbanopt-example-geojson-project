# frozen_string_literal: true

require_relative '../../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/minitest_helper'
require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
# require 'fileutils'
require_relative '../measure.rb'

class BuildResidentialModelTest < Minitest::Test
  def setup
    @tests_path = File.dirname(__FILE__)
    @run_path = File.join(@tests_path, 'run')
    @hpxml_path = File.join(@run_path, 'feature.xml')
  
    @args_hash = {}
    @args_hash['hpxml_path'] = @hpxml_path
    @args_hash['output_dir'] = @run_path
  end

  def teardown
    FileUtils.rm_rf(@run_path)
  end

  def test_stochastic
    @args_hash['feature_id'] = 1
    @args_hash['schedules_type'] = 'stochastic'
    @args_hash['schedules_random_seed'] = 1
    @args_hash['schedules_variation'] = 'unit'
    @args_hash['geometry_num_floors_above_grade'] = 1
    @args_hash['geometry_building_num_units'] = 1

    _test_measure()
  end

  def _test_measure(expect_fail: false)
    # create an instance of the measure
    measure = BuildResidentialModel.new

    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)
    model = OpenStudio::Model::Model.new

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if @args_hash.has_key?(arg.name)
        assert(temp_arg_var.setValue(@args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # assert that it ran correctly
    if expect_fail
      show_output(result) unless result.value.valueName == 'Fail'
      assert_equal('Fail', result.value.valueName)
    else
      show_output(result) unless result.value.valueName == 'Success'
      assert_equal('Success', result.value.valueName)
    end
  end

  def _create_hpxml(hpxml_name)
    return HPXML.new(hpxml_path: File.join(@sample_files_path, hpxml_name), building_id: 'ALL')
  end
end
