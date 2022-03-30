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

# frozen_string_literal: true

require_relative '../resources/minitest_helper'
require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'
require_relative '../measure.rb'
require_relative '../resources/util.rb'

class HPXMLtoOpenStudioSimControlsTest < MiniTest::Test
  def setup
    @root_path = File.absolute_path(File.join(File.dirname(__FILE__), '..', '..'))
    @sample_files_path = File.join(@root_path, 'workflow', 'sample_files')
    @tmp_hpxml_path = File.join(@sample_files_path, 'tmp.xml')
    @tmp_output_path = File.join(@sample_files_path, 'tmp_output')
    FileUtils.mkdir_p(@tmp_output_path)
  end

  def teardown
    File.delete(@tmp_hpxml_path) if File.exist? @tmp_hpxml_path
    FileUtils.rm_rf(@tmp_output_path)
  end

  def sample_files_dir
    return File.join(File.dirname(__FILE__), '..', '..', 'workflow', 'sample_files')
  end

  def test_default_schedules
    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(File.join(sample_files_dir, 'base.xml'))
    model, hpxml = _test_measure(args_hash)

    schedule_constants = 9
    schedule_rulesets = 17
    schedule_fixed_intervals = 1
    schedule_files = 0

    assert_equal(schedule_constants, model.getScheduleConstants.size)
    assert_equal(schedule_rulesets, model.getScheduleRulesets.size)
    assert_equal(schedule_fixed_intervals, model.getScheduleFixedIntervals.size)
    assert_equal(schedule_files, model.getScheduleFiles.size)
    assert_equal(model.getSchedules.size, schedule_constants + schedule_rulesets + schedule_fixed_intervals + schedule_files)
  end

  def test_stochastic_schedules
    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(File.join(sample_files_dir, 'base-schedules-detailed-stochastic.xml'))
    model, hpxml = _test_measure(args_hash)

    schedule_constants = 9
    schedule_rulesets = 5
    schedule_fixed_intervals = 1
    schedule_files = 13

    assert_equal(schedule_constants, model.getScheduleConstants.size)
    assert_equal(schedule_rulesets, model.getScheduleRulesets.size)
    assert_equal(schedule_fixed_intervals, model.getScheduleFixedIntervals.size)
    assert_equal(schedule_files, model.getScheduleFiles.size)
    assert_equal(model.getSchedules.size, schedule_constants + schedule_rulesets + schedule_fixed_intervals + schedule_files)

    schedule_file_names = []
    model.getScheduleFiles.each do |schedule_file|
      schedule_file_names << "#{schedule_file.name}"
    end
    assert(schedule_file_names.include?('occupants'))
    assert(schedule_file_names.include?('lighting_interior'))
    assert(schedule_file_names.include?('lighting_exterior'))
    assert(!schedule_file_names.include?('lighting_garage'))
    assert(!schedule_file_names.include?('lighting_exterior_holiday'))
    assert(schedule_file_names.include?('cooking_range'))
    assert(schedule_file_names.include?('refrigerator'))
    assert(!schedule_file_names.include?('extra_refrigerator'))
    assert(!schedule_file_names.include?('freezer'))
    assert(schedule_file_names.include?('dishwasher'))
    assert(schedule_file_names.include?('clothes_washer'))
    assert(schedule_file_names.include?('clothes_dryer'))
    assert(!schedule_file_names.include?('ceiling_fan'))
    assert(schedule_file_names.include?('plug_loads_other'))
    assert(schedule_file_names.include?('plug_loads_tv'))
    assert(!schedule_file_names.include?('plug_loads_vehicle'))
    assert(!schedule_file_names.include?('plug_loads_well_pump'))
    assert(!schedule_file_names.include?('fuel_loads_grill'))
    assert(!schedule_file_names.include?('fuel_loads_lighting'))
    assert(!schedule_file_names.include?('fuel_loads_fireplace'))
    assert(!schedule_file_names.include?('pool_pump'))
    assert(!schedule_file_names.include?('pool_heater'))
    assert(!schedule_file_names.include?('hot_tub_pump'))
    assert(!schedule_file_names.include?('hot_tub_heater'))
    assert(schedule_file_names.include?('hot_water_clothes_washer'))
    assert(schedule_file_names.include?('hot_water_dishwasher'))
    assert(schedule_file_names.include?('hot_water_fixtures'))

    # add a pool
    hpxml.pools.add(id: 'Pool',
                    type: HPXML::TypeUnknown,
                    pump_type: HPXML::TypeUnknown,
                    pump_kwh_per_year: 2700,
                    heater_type: HPXML::HeaterTypeGas,
                    heater_load_units: HPXML::UnitsThermPerYear,
                    heater_load_value: 500)

    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(@tmp_hpxml_path)
    XMLHelper.write_file(hpxml.to_oga, @tmp_hpxml_path)
    model, hpxml = _test_measure(args_hash)

    schedule_file_names = []
    model.getScheduleFiles.each do |schedule_file|
      schedule_file_names << "#{schedule_file.name}"
    end
    assert(schedule_file_names.include?('pool_pump'))
    assert(schedule_file_names.include?('pool_heater'))
  end

  def test_stochastic_vacancy_schedules
    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(File.join(sample_files_dir, 'base-schedules-detailed-stochastic-vacancy.xml'))
    model, hpxml = _test_measure(args_hash)

    schedule_constants = 9
    schedule_rulesets = 5
    schedule_fixed_intervals = 1
    schedule_files = 13

    assert_equal(schedule_constants, model.getScheduleConstants.size)
    assert_equal(schedule_rulesets, model.getScheduleRulesets.size)
    assert_equal(schedule_fixed_intervals, model.getScheduleFixedIntervals.size)
    assert_equal(schedule_files, model.getScheduleFiles.size)
    assert_equal(model.getSchedules.size, schedule_constants + schedule_rulesets + schedule_fixed_intervals + schedule_files)
  end

  def test_smooth_schedules
    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(File.join(sample_files_dir, 'base-schedules-detailed-smooth.xml'))
    model, hpxml = _test_measure(args_hash)

    schedule_constants = 9
    schedule_rulesets = 5
    schedule_fixed_intervals = 1
    schedule_files = 13

    assert_equal(schedule_constants, model.getScheduleConstants.size)
    assert_equal(schedule_rulesets, model.getScheduleRulesets.size)
    assert_equal(schedule_fixed_intervals, model.getScheduleFixedIntervals.size)
    assert_equal(schedule_files, model.getScheduleFiles.size)
    assert_equal(model.getSchedules.size, schedule_constants + schedule_rulesets + schedule_fixed_intervals + schedule_files)
  end

  def _test_measure(args_hash)
    # create an instance of the measure
    measure = HPXMLtoOpenStudio.new

    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)
    model = OpenStudio::Model::Model.new

    # get arguments
    args_hash['output_dir'] = 'tests'
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.has_key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result) unless result.value.valueName == 'Success'

    # assert that it ran correctly
    assert_equal('Success', result.value.valueName)

    hpxml = HPXML.new(hpxml_path: args_hash['hpxml_path'])

    File.delete(File.join(File.dirname(__FILE__), 'in.xml'))

    return model, hpxml
  end
end
