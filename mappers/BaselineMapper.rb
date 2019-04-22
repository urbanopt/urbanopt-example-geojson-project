#*********************************************************************************
# URBANopt, Copyright (c) 2019, Alliance for Sustainable Energy, LLC, and other
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

require 'json'

module URBANopt
  module Scenario
    class BaselineMapper < MapperBase

      # class level variables
      @@instance_lock = Mutex.new
      @@osw = nil
      @@geometry = nil

      def initialize()

        # do initialization of class variables in thread safe way
        @@instance_lock.synchronize do
          if @@osw.nil?

            # load the OSW for this class
            osw_path = File.join(File.dirname(__FILE__), 'baseline.osw')
            File.open(osw_path, 'r') do |file|
              @@osw = JSON.parse(file.read, symbolize_names: true)
            end

            # add any paths local to the project
            @@osw[:file_paths] << File.join(File.dirname(__FILE__), '../weather/')

            # configures OSW with extension gem paths for measures and files, all extension gems must be
            # required before this
            @@osw = OpenStudio::Extension.configure_osw(@@osw)
          end
        end
      end

      def create_osw(scenario, feature_id, feature_name)

        # find a feature by id
        feature_file = scenario.feature_file
        feature = feature_file.get_feature(feature_id)

        raise "Cannot find feature '#{feature_id}' in '#{scenario.geometry_file}'" if feature.nil?

        # deep clone of @@osw before we configure it
        osw = Marshal.load(Marshal.dump(@@osw))

        # get properties out of the feature
        area = feature.area
        building_type = feature.building_type
        cooling_source = feature.cooling_source
        heating_source = feature.heating_source

        # now we have the feature, we can look up its properties and set arguments in the OSW
        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_a', building_type)
        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'total_bldg_floor_area', area)

        OpenStudio::Extension.set_measure_argument(osw, 'create_typical_building_from_model', 'htg_src', heating_source)
        OpenStudio::Extension.set_measure_argument(osw, 'create_typical_building_from_model', 'clg_src', cooling_source)

        osw[:name] = feature_name
        osw[:description] = feature_name

        return osw
      end

    end
  end
end