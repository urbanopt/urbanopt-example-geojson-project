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

require 'urbanopt/core/feature'
require 'urbanopt/core/feature_file'

class ExampleFeature < URBANopt::Core::Feature
  def initialize(json)
    super()
    @id = json[:id]
    @name = json[:name]
    @json = json
  end
  
  def area
    @json[:area]
  end
  
  def building_type
    @json[:building_type]
  end
  
  def cooling_source
    @json[:cooling_source]
  end
  
  def heating_source
    @json[:heating_source]
  end
  
end

# Simple example of a FeatureFile
class ExampleFeatureFile < URBANopt::Core::FeatureFile

  def initialize(path)
    super()
    
    @path = path
    
    @json = nil
    File.open(path, 'r') do |file|
      @json = JSON.parse(file.read, symbolize_names: true)
    end
    
    @features = []
    @json[:buildings].each do |building|
      @features << ExampleFeature.new(building)
    end
  end

  def path()
    @path
  end

  def features()
    result = []
    @features
  end

  def get_feature_by_id(id)
    @features.each do |f|
      if f.id == id
        return f
      end
    end
    return nil
  end

end
