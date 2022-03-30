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

class SimControls
  def self.apply(model, hpxml)
    sim = model.getSimulationControl
    sim.setRunSimulationforSizingPeriods(false)

    tstep = model.getTimestep
    tstep.setNumberOfTimestepsPerHour(60 / hpxml.header.timestep)

    shad = model.getShadowCalculation
    shad.setMaximumFiguresInShadowOverlapCalculations(200)
    # Use EnergyPlus default of 20 days for update frequency; it is a reasonable balance
    # between speed and accuracy (e.g., sun position, picking up any change in window
    # interior shading transmittance, etc.).
    shad.setShadingCalculationUpdateFrequency(20)

    has_windows_varying_transmittance = false
    hpxml.windows.each do |window|
      sf_summer = window.interior_shading_factor_summer * window.exterior_shading_factor_summer
      sf_winter = window.interior_shading_factor_winter * window.exterior_shading_factor_winter
      next if sf_summer == sf_winter

      has_windows_varying_transmittance = true
    end
    if has_windows_varying_transmittance
      # Detailed diffuse algorithm is required for window interior shading with varying
      # transmittance schedules
      shad.setSkyDiffuseModelingAlgorithm('DetailedSkyDiffuseModeling')
    end

    outsurf = model.getOutsideSurfaceConvectionAlgorithm
    outsurf.setAlgorithm('DOE-2')

    insurf = model.getInsideSurfaceConvectionAlgorithm
    insurf.setAlgorithm('TARP')

    zonecap = model.getZoneCapacitanceMultiplierResearchSpecial
    zonecap.setHumidityCapacityMultiplier(15)

    convlim = model.getConvergenceLimits
    convlim.setMinimumSystemTimestep(0)

    run_period = model.getRunPeriod
    run_period.setBeginMonth(hpxml.header.sim_begin_month)
    run_period.setBeginDayOfMonth(hpxml.header.sim_begin_day)
    run_period.setEndMonth(hpxml.header.sim_end_month)
    run_period.setEndDayOfMonth(hpxml.header.sim_end_day)
  end
end
