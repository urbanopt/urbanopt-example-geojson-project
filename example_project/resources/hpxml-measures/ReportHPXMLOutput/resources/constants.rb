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

class BS
  WallAboveGradeConditioned = 'Enclosure: Wall Area Thermal Boundary'
  WallAboveGradeExterior = 'Enclosure: Wall Area Exterior'
  WallBelowGrade = 'Enclosure: Foundation Wall Area Exterior'
  FloorConditioned = 'Enclosure: Floor Area Conditioned'
  FloorLighting = 'Enclosure: Floor Area Lighting'
  Ceiling = 'Enclosure: Ceiling Area Thermal Boundary'
  Roof = 'Enclosure: Roof Area'
  Window = 'Enclosure: Window Area'
  Door = 'Enclosure: Door Area'
  DuctUnconditioned = 'Enclosure: Duct Area Unconditioned'
  RimJoistAboveGradeExterior = 'Enclosure: Rim Joist Area'
  SlabPerimeterExposedConditioned = 'Enclosure: Slab Exposed Perimeter Thermal Boundary'
  HeatingSystem = 'Systems: Heating Capacity'
  CoolingSystem = 'Systems: Cooling Capacity'
  HeatPumpBackup = 'Systems: Heat Pump Backup Capacity'
  WaterHeater = 'Systems: Water Heater Tank Volume'
  FlowRateMechanicalVentilation = 'Systems: Mechanical Ventilation Flow Rate'

  HeatingTotal = 'Design Loads Heating: Total'
  HeatingDucts = 'Design Loads Heating: Ducts'
  HeatingWindows = 'Design Loads Heating: Windows'
  HeatingSkylights = 'Design Loads Heating: Skylights'
  HeatingDoors = 'Design Loads Heating: Doors'
  HeatingWalls = 'Design Loads Heating: Walls'
  HeatingRoofs = 'Design Loads Heating: Roofs'
  HeatingFloors = 'Design Loads Heating: Floors'
  HeatingSlabs = 'Design Loads Heating: Slabs'
  HeatingCeilings = 'Design Loads Heating: Ceilings'
  HeatingInfilVent = 'Design Loads Heating: Infiltration/Ventilation'

  CoolingSensibleTotal = 'Design Loads Cooling Sensible: Total'
  CoolingSensibleDucts = 'Design Loads Cooling Sensible: Ducts'
  CoolingSensibleWindows = 'Design Loads Cooling Sensible: Windows'
  CoolingSensibleSkylights = 'Design Loads Cooling Sensible: Skylights'
  CoolingSensibleDoors = 'Design Loads Cooling Sensible: Doors'
  CoolingSensibleWalls = 'Design Loads Cooling Sensible: Walls'
  CoolingSensibleRoofs = 'Design Loads Cooling Sensible: Roofs'
  CoolingSensibleFloors = 'Design Loads Cooling Sensible: Floors'
  CoolingSensibleSlabs = 'Design Loads Cooling Sensible: Slabs'
  CoolingSensibleCeilings = 'Design Loads Cooling Sensible: Ceilings'
  CoolingSensibleInfilVent = 'Design Loads Cooling Sensible: Infiltration/Ventilation'
  CoolingSensibleIntGains = 'Design Loads Cooling Sensible: Internal Gains'

  CoolingLatentTotal = 'Design Loads Cooling Latent: Total'
  CoolingLatentDucts = 'Design Loads Cooling Latent: Ducts'
  CoolingLatentInfilVent = 'Design Loads Cooling Latent: Infiltration/Ventilation'
  CoolingLatentIntGains = 'Design Loads Cooling Latent: Internal Gains'

  def self.get_units(cost_mult_type)
    if cost_mult_type.include?('Area')
      return 'ft^2'
    elsif cost_mult_type.include?('Perimeter')
      return 'ft'
    elsif cost_mult_type.include?('Capacity')
      return 'Btu/h'
    elsif cost_mult_type.include?('Tank Volume')
      return 'gal'
    elsif cost_mult_type.include?('Flow Rate')
      return 'cfm'
    elsif cost_mult_type == 'Fixed'
      return '1'
    elsif cost_mult_type.include?('Design Loads')
      return 'Btu/h'
    end

    fail "Unable to assign units to: #{cost_mult_type}"
  end
end
