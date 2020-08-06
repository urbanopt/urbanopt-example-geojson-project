#*********************************************************************************
# URBANopt, Copyright (c) 2019-2020, Alliance for Sustainable Energy, LLC, and other 
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

require 'urbanopt/scenario'
require 'openstudio/common_measures'
require 'openstudio/model_articulation'
require 'openstudio/load_flexibility_measures'

require_relative 'Baseline'

require 'json'

module URBANopt
  module Scenario
    class ThermalStorageMapper < HighEfficiencyMapper
      
      def create_osw(scenario, features, feature_names)
      
        osw = super(scenario, features, feature_names)

        # Add ice to applicable TES object building and set applicable charge and discharge times

        if feature_names[0].to_s == 'Mixed_use 1'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_ice_storage_to_plant_loop_for_load_flexibility', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_ice_storage_to_plant_loop_for_load_flexibility', 'storage_capacity', 6000)
        end

        if feature_names[0].to_s == 'Restaurant 1'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', false)
        end

        if feature_names[0].to_s == 'Restaurant 10'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', false)
        end

        if feature_names[0].to_s == 'Restaurant 12'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', false)
        end

        if feature_names[0].to_s == 'Restaurant 14'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', false)
        end

        if feature_names[0].to_s == 'Restaurant 15'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', false)
        end

        if feature_names[0].to_s == 'Office 1'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_ice_storage_to_plant_loop_for_load_flexibility', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_ice_storage_to_plant_loop_for_load_flexibility', 'storage_capacity', 1200)
        end

        if feature_names[0].to_s == 'Hospital 1'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_ice_storage_to_plant_loop_for_load_flexibility', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_ice_storage_to_plant_loop_for_load_flexibility', 'storage_capacity', 3000)
        end

        if feature_names[0].to_s == 'Hospital 2'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_ice_storage_to_plant_loop_for_load_flexibility', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_ice_storage_to_plant_loop_for_load_flexibility', 'storage_capacity', 900)
        end

        if feature_names[0].to_s == 'Mixed use 2'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_ice_storage_to_plant_loop_for_load_flexibility', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_ice_storage_to_plant_loop_for_load_flexibility', 'storage_capacity', 7000)
        end

        if feature_names[0].to_s == 'Restaurant 13'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', false)
        end

        if feature_names[0].to_s == 'Mall 1'
          OpenStudio::Extension.set_measure_argument(osw,
                                                     'add_ice_storage_to_plant_loop_for_load_flexibility', '__SKIP__', false)
          OpenStudio::Extension.set_measure_argument(osw, 'add_ice_storage_to_plant_loop_for_load_flexibility', 'storage_capacity', 1500)
        end

        if feature_names[0].to_s == 'Hotel 1'
          # This feature needs revision - PTAC coils need to be explicitly excluded
          # Turn off for now.
          OpenStudio::Extension.set_measure_argument(osw, 'add_distributed_ice_storage_to_air_loop_for_load_flexibility', '__SKIP__', true)
        end

        return osw
      end
      
    end
  end
end