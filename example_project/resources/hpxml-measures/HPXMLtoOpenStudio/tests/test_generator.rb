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

class HPXMLtoOpenStudioGeneratorTest < MiniTest::Test
  def sample_files_dir
    return File.join(File.dirname(__FILE__), '..', '..', 'workflow', 'sample_files')
  end

  def get_generator(model, name)
    model.getGeneratorMicroTurbines.each do |g|
      next unless g.name.to_s.start_with? "#{name} "

      return g
    end
  end

  def test_generator
    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(File.join(sample_files_dir, 'base-misc-generators.xml'))
    model, hpxml = _test_measure(args_hash)

    hpxml.generators.each do |hpxml_generator|
      generator = get_generator(model, hpxml_generator.id)

      # Check object
      assert_equal(EPlus.fuel_type(hpxml_generator.fuel_type), generator.fuelType)
      assert_in_epsilon(57.1, generator.referenceElectricalPowerOutput, 0.01)
      assert_in_epsilon(57.1, generator.minimumFullLoadElectricalPowerOutput, 0.01)
      assert_in_epsilon(57.1, generator.maximumFullLoadElectricalPowerOutput, 0.01)
      assert_in_epsilon(0.2, generator.referenceElectricalEfficiencyUsingLowerHeatingValue, 0.01)
      assert_equal(generator.fuelHigherHeatingValue, generator.fuelLowerHeatingValue)
      assert_equal(0, generator.standbyPower)
      assert_equal(0, generator.ancillaryPower)
    end
  end

  def test_generator_shared
    args_hash = {}
    args_hash['hpxml_path'] = File.absolute_path(File.join(sample_files_dir, 'base-bldgtype-multifamily-shared-generator.xml'))
    model, hpxml = _test_measure(args_hash)

    hpxml.generators.each do |hpxml_generator|
      generator = get_generator(model, hpxml_generator.id)

      # Check object
      assert_equal(EPlus.fuel_type(hpxml_generator.fuel_type), generator.fuelType)
      assert_in_epsilon(95.1, generator.referenceElectricalPowerOutput, 0.01)
      assert_in_epsilon(95.1, generator.minimumFullLoadElectricalPowerOutput, 0.01)
      assert_in_epsilon(95.1, generator.maximumFullLoadElectricalPowerOutput, 0.01)
      assert_in_epsilon(0.2, generator.referenceElectricalEfficiencyUsingLowerHeatingValue, 0.01)
      assert_equal(generator.fuelHigherHeatingValue, generator.fuelLowerHeatingValue)
      assert_equal(0, generator.standbyPower)
      assert_equal(0, generator.ancillaryPower)
    end
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
