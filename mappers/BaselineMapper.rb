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
        
        if feature_type == 'Building'
          
          building_type_1 = feature.building_type

          case building_type_1
          when 'Multifamily (5 or more units)'
            building_type_1 = 'MidriseApartment'
          when 'Multifamily (2 to 4 units)'
            building_type_1 = 'MidriseApartment'
          when 'Single-Family'
            building_type_1 = 'MidriseApartment'
          when 'Office'
            building_type_1 = 'MediumOffice'
          when 'Mixed use'
            mixed_type_1 = feature.mixed_type_1
            mixed_type_2 = feature.mixed_type_2
            mixed_type_2_percentage = feature.mixed_type_2_percentage
            mixed_type_2_fract_bldg_area = mixed_type_2_percentage/100
    
            mixed_type_3 = feature.mixed_type_3
            mixed_type_3_percentage = feature.mixed_type_3_percentage
            mixed_type_3_fract_bldg_area = mixed_type_2_percentage/100
    
            mixed_type_4 = feature.mixed_type_4
            mixed_type_4_percentage = feature.mixed_type_4_percentage
            mixed_type_4_fract_bldg_area = mixed_type_4_percentage/100
          end
          
          footprint_area = feature.footprint_area
          height = feature.height
          number_of_stories_above_ground = feature.number_of_stories_above_ground
          number_of_stories = feature.number_of_stories 
          number_of_stories_below_ground = number_of_stories - number_of_stories_above_ground 
         #template = feature.template
        end

        heating_vac = feature.heating_vac
        cooling_vac = feature.cooling_vac

        # deep clone of @@osw before we configure it
        osw = Marshal.load(Marshal.dump(@@osw))
        
        # now we have the feature, we can look up its properties and set arguments in the OSW
        OpenStudio::Extension.set_measure_argument(osw, 'urban_geometry_creation', 'geojson_file', scenario.feature_file.path)
        puts "2HELLO = #{scenario.feature_file.path}"
        OpenStudio::Extension.set_measure_argument(osw, 'urban_geometry_creation', 'feature_id', feature_id)
        OpenStudio::Extension.set_measure_argument(osw, 'urban_geometry_creation', 'surrounding_buildings', 'None')
        
        OpenStudio::Extension.set_measure_argument(osw, 'default_feature_reports', 'feature_id', feature_id)
        OpenStudio::Extension.set_measure_argument(osw, 'default_feature_reports', 'feature_name', feature_name)
        OpenStudio::Extension.set_measure_argument(osw, 'default_feature_reports', 'feature_type', feature_type)
        
        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'single_floor_area', footprint_area)
        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'floor_height', height)
        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'num_stories_above_grade', number_of_stories_above_ground)
        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'num_stories_below_grade', number_of_stories_below_ground)
        #OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'template', template)

        OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_a', building_type_1)
        
        if building_type_1 == 'Mixed use'

          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_a', mixed_type_1)
          
          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_b', mixed_type_2)
          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_b_fract_bldg_area', mixed_type_2_fract_bldg_area)
          
          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_c', mixed_type_3)
          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_c_fract_bldg_area', mixed_type_3_fract_bldg_area)

          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_d', mixed_type_4)
          OpenStudio::Extension.set_measure_argument(osw, 'create_bar_from_building_type_ratios', 'bldg_type_d_fract_bldg_area', mixed_type_4_fract_bldg_area)      
        
        end
        
        OpenStudio::Extension.set_measure_argument(osw, 'create_typical_building_from_model', 'htg_src', heating_vac)
        OpenStudio::Extension.set_measure_argument(osw, 'create_typical_building_from_model', 'clg_src', cooling_vac)

        osw[:name] = feature_name
        osw[:description] = feature_name
        
        return osw
      end
      
    end
  end
end