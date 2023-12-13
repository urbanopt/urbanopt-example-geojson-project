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
    FileUtils.mkdir_p(@run_path)
  
    @args_hash = {}
    @args_hash['hpxml_path'] = @hpxml_path
    @args_hash['output_dir'] = @run_path
    @args_hash['feature_id'] = 1
    @args_hash['schedules_type'] = 'stochastic'
    @args_hash['schedules_random_seed'] = 1
    @args_hash['schedules_variation'] = 'unit'
    @args_hash['geometry_num_floors_above_grade'] = 1
    @args_hash['geometry_building_num_units'] = 1
  end

  def teardown
    FileUtils.rm_rf(@run_path)
  end

  def test_schedules_type
    schedules_types = ['stochastic', 'smooth']

    schedules_types.each do |schedules_type|
      @args_hash['schedules_type'] = schedules_type

      _test_measure()
    end
  end

  def test_types_and_floors_and_units
    @args_hash['air_leakage_type'] = 'unit exterior only'

    geometry_unit_types = ['single-family detached', 'single-family attached', 'apartment unit']
    geometry_num_floors_above_grades = (1..2).to_a
    geometry_building_num_unitss = (1..3).to_a
    geometry_unit_types.each do |geometry_unit_type|
      geometry_num_floors_above_grades.each do |geometry_num_floors_above_grade|
        geometry_building_num_unitss.each do |geometry_building_num_units|
          @args_hash['geometry_unit_type'] = geometry_unit_type
          @args_hash['geometry_num_floors_above_grade'] = geometry_num_floors_above_grade
          @args_hash['geometry_building_num_units'] = geometry_building_num_units

          @args_hash['geometry_unit_num_floors_above_grade'] = 1
          @args_hash['geometry_unit_num_floors_above_grade'] = geometry_num_floors_above_grade if ['single-family detached', 'single-family attached'].include?(geometry_unit_type)

          expect_fail = false
          if geometry_unit_type == 'single-family detached' && geometry_building_num_units > 1
            expect_fail = true
          end
          if geometry_unit_type == 'apartment unit' && (Float(geometry_building_num_units) / Float(geometry_num_floors_above_grade)).ceil == 1
            expect_fail = true
          end

          _test_measure(expect_fail: expect_fail)
        end
      end
    end
  end

  def test_hpxml_dir
    @args_hash['hpxml_dir'] = '17'
    _test_measure(expect_fail: true)

    @args_hash['geometry_building_num_units'] = 4
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
