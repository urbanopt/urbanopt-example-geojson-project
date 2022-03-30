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

class Generator
  def self.apply(model, nbeds, generator)
    obj_name = generator.id

    if not generator.is_shared_system
      annual_consumption_kbtu = generator.annual_consumption_kbtu
      annual_output_kwh = generator.annual_output_kwh
    else
      # Apportion to single dwelling unit by # bedrooms
      fail if generator.number_of_bedrooms_served.to_f <= nbeds.to_f # EPvalidator.xml should prevent this

      annual_consumption_kbtu = generator.annual_consumption_kbtu * nbeds.to_f / generator.number_of_bedrooms_served.to_f
      annual_output_kwh = generator.annual_output_kwh * nbeds.to_f / generator.number_of_bedrooms_served.to_f
    end

    input_w = UnitConversions.convert(annual_consumption_kbtu, 'kBtu', 'Wh') / 8760.0
    output_w = UnitConversions.convert(annual_output_kwh, 'kWh', 'Wh') / 8760.0
    efficiency = output_w / input_w
    fail if efficiency > 1.0 # EPvalidator.xml should prevent this

    curve_biquadratic_constant = create_curve_biquadratic_constant(model)
    curve_cubic_constant = create_curve_cubic_constant(model)

    gmt = OpenStudio::Model::GeneratorMicroTurbine.new(model)
    gmt.setName("#{obj_name} generator")
    gmt.setFuelType(EPlus.fuel_type(generator.fuel_type))
    gmt.setReferenceElectricalPowerOutput(output_w)
    gmt.setMinimumFullLoadElectricalPowerOutput(output_w - 0.001)
    gmt.setMaximumFullLoadElectricalPowerOutput(output_w)
    gmt.setReferenceElectricalEfficiencyUsingLowerHeatingValue(efficiency)
    gmt.setFuelHigherHeatingValue(50000)
    gmt.setFuelLowerHeatingValue(50000)
    gmt.setStandbyPower(0.0)
    gmt.setAncillaryPower(0.0)
    gmt.electricalPowerFunctionofTemperatureandElevationCurve.remove
    gmt.electricalEfficiencyFunctionofTemperatureCurve.remove
    gmt.electricalEfficiencyFunctionofPartLoadRatioCurve.remove
    gmt.setElectricalPowerFunctionofTemperatureandElevationCurve(curve_biquadratic_constant)
    gmt.setElectricalEfficiencyFunctionofTemperatureCurve(curve_cubic_constant)
    gmt.setElectricalEfficiencyFunctionofPartLoadRatioCurve(curve_cubic_constant)

    elcd = OpenStudio::Model::ElectricLoadCenterDistribution.new(model)
    elcd.setName("#{obj_name} elec load center dist")
    elcd.setGeneratorOperationSchemeType('Baseload')
    elcd.addGenerator(gmt)
    elcd.setElectricalBussType('AlternatingCurrent')
  end

  def self.create_curve_cubic_constant(model)
    constant_cubic = OpenStudio::Model::CurveCubic.new(model)
    constant_cubic.setName('ConstantCubic')
    constant_cubic.setCoefficient1Constant(1)
    constant_cubic.setCoefficient2x(0)
    constant_cubic.setCoefficient3xPOW2(0)
    constant_cubic.setCoefficient4xPOW3(0)
    # constant_cubic.setMinimumValueofx(-100)
    # constant_cubic.setMaximumValueofx(100)
    return constant_cubic
  end

  def self.create_curve_biquadratic_constant(model)
    const_biquadratic = OpenStudio::Model::CurveBiquadratic.new(model)
    const_biquadratic.setName('ConstantBiquadratic')
    const_biquadratic.setCoefficient1Constant(1)
    const_biquadratic.setCoefficient2x(0)
    const_biquadratic.setCoefficient3xPOW2(0)
    const_biquadratic.setCoefficient4y(0)
    const_biquadratic.setCoefficient5yPOW2(0)
    const_biquadratic.setCoefficient6xTIMESY(0)
    # const_biquadratic.setMinimumValueofx(-100)
    # const_biquadratic.setMaximumValueofx(100)
    # const_biquadratic.setMinimumValueofy(-100)
    # const_biquadratic.setMaximumValueofy(100)
    return const_biquadratic
  end
end
