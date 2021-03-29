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
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
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

require 'urbanopt/reporting'
require 'openstudio/common_measures'
require 'openstudio/model_articulation'

require_relative 'Baseline'

require 'json'

module URBANopt
  module Scenario
    class TemperatureAdjusted < BaselineMapper

      def create_osw(scenario, features, feature_names)

        osw = super(scenario, features, feature_names)

        feature = features[0]
        building_type = feature.building_type

        
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', '__SKIP__', false)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_1_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_2_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_3_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_4_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_5_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_6_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_7_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_8_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_9_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_10_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_11_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_12_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_13_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_14_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_15_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_16_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_17_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_18_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_19_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_20_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_21_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_22_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_23_setpoint', 0)
		OpenStudio::Extension.set_measure_argument(osw, 'adjustment_of_cooling_setpoints_hourlyd_by_degrees_c_allday', 'hour_24_setpoint', 0)
		

        return osw
      end

    end
  end
end
