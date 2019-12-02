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
    class BaselineMapper < SimulationMapperBase
    
      # class level variables
      @@instance_lock = Mutex.new
      @@osw = nil
      @@geometry = nil
    
      def initialize()
      
        # do initialization of class variables in thread safe way
        @@instance_lock.synchronize do
          if @@osw.nil? 
            
            # load the OSW for this class
            osw_path = File.join(File.dirname(__FILE__), 'base_workflow.osw')
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
      
      def create_osw(scenario, features, feature_names)
        
        if features.size != 1
          raise "TestMapper1 currently cannot simulate more than one feature"
        end
        feature = features[0]
        feature_id = feature.id
        feature_type = feature.type 
        feature_name = feature.name
        if feature_names.size == 1
          feature_name = feature_names[0]
        end          

        #system_type = "Inferred"

        # deep clone of @@osw before we configure it
        osw = Marshal.load(Marshal.dump(@@osw))
        
        # now we have the feature, we can look up its properties and set arguments in the OSW
        osw[:name] = feature_name
        osw[:description] = feature_name
        
        if feature_type == 'Building'
          if feature.detailed_model_filename
            detailed_model_name = feature.detailed_model_filename
            @@osw[:file_paths] << File.join(File.dirname(__FILE__), '../osm_building/')
            @@osw[:seed_file] = detailed_model_name
          end
        
          # call create typical building a second time, add hvac
          #OpenStudio::Extension.set_measure_argument(osw, 'create_typical_building_from_model', 'system_type', system_type)
            
          # call the default feature reporting measure
          OpenStudio::Extension.set_measure_argument(osw, 'default_feature_reports', 'feature_id', feature_id)
          OpenStudio::Extension.set_measure_argument(osw, 'default_feature_reports', 'feature_name', feature_name)
          OpenStudio::Extension.set_measure_argument(osw, 'default_feature_reports', 'feature_type', feature_type)
        end        

        return osw
      end
      
    end
  end
end