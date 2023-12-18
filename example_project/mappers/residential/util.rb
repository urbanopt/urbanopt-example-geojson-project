
def residential_simulation(args, timestep, run_period, calendar_year, weather_filename)
  args[:simulation_control_timestep] = timestep
  args[:simulation_control_run_period] = run_period
  args[:simulation_control_run_period_calendar_year] = calendar_year
  args[:weather_station_epw_filepath] = "../../../weather/#{weather_filename}"
end

def residential_geometry_unit(args, building_type, floor_area, number_of_bedrooms, geometry_unit_orientation, geometry_unit_aspect_ratio, occupancy_calculation_type, number_of_occupants, maximum_roof_height)
  number_of_stories_above_ground = args[:geometry_num_floors_above_grade]
  args[:geometry_unit_num_floors_above_grade] = 1
  case building_type
  when 'Single-Family Detached'
    args[:geometry_building_num_units] = 1
    args[:geometry_unit_type] = 'single-family detached'
    args[:geometry_unit_num_floors_above_grade] = number_of_stories_above_ground
  when 'Single-Family Attached'
    args[:geometry_unit_type] = 'single-family attached'
    args[:geometry_unit_num_floors_above_grade] = number_of_stories_above_ground
    args[:air_leakage_type] = 'unit exterior only'
  when 'Multifamily'
    args[:geometry_unit_type] = 'apartment unit'
    args[:air_leakage_type] = 'unit exterior only'
  end

  args[:geometry_unit_cfa] = floor_area / args[:geometry_building_num_units]

  args[:geometry_unit_num_bedrooms] = number_of_bedrooms / args[:geometry_building_num_units]

  # Geometry Orientation and Aspect Ratio
  # Orientation (North=0, East=90, South=180, West=270)
  args[:geometry_unit_orientation] = geometry_unit_orientation if !geometry_unit_orientation.nil?

  # Aspect Ratio
  # The ratio of front/back wall length to left/right wall length for the unit, excluding any protruding garage wall area.
  args[:geometry_unit_aspect_ratio] = geometry_unit_aspect_ratio if !geometry_unit_aspect_ratio.nil?

  # Occupancy Calculation Type
  if occupancy_calculation_type == 'operational'
    # set args[:geometry_unit_num_occupants]
    begin
      args[:geometry_unit_num_occupants] = number_of_occupants / args[:geometry_building_num_units]
    rescue StandardError # number_of_occupants is not defined: assume equal to number of bedrooms
      args[:geometry_unit_num_occupants] = args[:geometry_unit_num_bedrooms]
    end
  else # nil or asset
    # do not set args[:geometry_unit_num_occupants]
  end

  args[:geometry_average_ceiling_height] = maximum_roof_height / number_of_stories_above_ground
end

def residential_geometry_foundation(args, foundation_type)
  args[:geometry_foundation_type] = 'SlabOnGrade'
  args[:geometry_foundation_height] = 0.0
  case foundation_type
  when 'crawlspace - vented'
    args[:geometry_foundation_type] = 'VentedCrawlspace'
    args[:geometry_foundation_height] = 3.0
  when 'crawlspace - unvented'
    args[:geometry_foundation_type] = 'UnventedCrawlspace'
    args[:geometry_foundation_height] = 3.0
  when 'crawlspace - conditioned'
    args[:geometry_foundation_type] = 'ConditionedCrawlspace'
    args[:geometry_foundation_height] = 3.0
  when 'basement - unconditioned'
    args[:geometry_foundation_type] = 'UnconditionedBasement'
    args[:geometry_foundation_height] = 8.0
  when 'basement - conditioned'
    args[:geometry_foundation_type] = 'ConditionedBasement'
    args[:geometry_foundation_height] = 8.0
  when 'ambient'
    args[:geometry_foundation_type] = 'Ambient'
    args[:geometry_foundation_height] = 8.0
  end
end

def residential_geometry_attic(args, attic_type, roof_type)
  begin
    case attic_type
    when 'attic - vented'
      args[:geometry_attic_type] = 'VentedAttic'
    when 'attic - unvented'
      args[:geometry_attic_type] = 'UnventedAttic'
    when 'attic - conditioned'
      args[:geometry_attic_type] = 'ConditionedAttic'
    when 'flat roof'
      args[:geometry_attic_type] = 'FlatRoof'
    end
  rescue StandardError
  end

  case roof_type
  when 'Gable'
    args[:geometry_roof_type] = 'gable'
  when 'Hip'
    args[:geometry_roof_type] = 'hip'
  end
end

def residential_geometry_garage(args, onsite_parking_fraction)
  num_garage_spaces = 0
  if onsite_parking_fraction
    num_garage_spaces = 1
    if args[:geometry_unit_cfa] > 2500.0
      num_garage_spaces = 2
    end
  end
  args[:geometry_garage_width] = 12.0 * num_garage_spaces
  args[:geometry_garage_protrusion] = 1.0
end

def residential_geometry_neighbor(args)
  args[:neighbor_left_distance] = 0.0
  args[:neighbor_right_distance] = 0.0
end

def residential_hvac(args, system_type, heating_system_fuel_type)
  system_type = 'Residential - furnace and central air conditioner'
  begin
    system_type = system_type
  rescue StandardError
  end

  args[:heating_system_type] = 'none'
  if system_type.include?('electric resistance')
    args[:heating_system_type] = 'ElectricResistance'
  elsif system_type.include?('furnace')
    args[:heating_system_type] = 'Furnace'
  elsif system_type.include?('boiler')
    args[:heating_system_type] = 'Boiler'
  end

  args[:cooling_system_type] = 'none'
  if system_type.include?('central air conditioner')
    args[:cooling_system_type] = 'central air conditioner'
  elsif system_type.include?('room air conditioner')
    args[:cooling_system_type] = 'room air conditioner'
  elsif system_type.include?('evaporative cooler')
    args[:cooling_system_type] = 'evaporative cooler'
  end

  args[:heat_pump_type] = 'none'
  if system_type.include?('air-to-air')
    args[:heat_pump_type] = 'air-to-air'
  elsif system_type.include?('mini-split')
    args[:heat_pump_type] = 'mini-split'
  elsif system_type.include?('ground-to-air')
    args[:heat_pump_type] = 'ground-to-air'
  end

  args[:heating_system_fuel] = 'natural gas'
  begin
    args[:heating_system_fuel] = heating_system_fuel_type
  rescue StandardError
  end

  if args[:heating_system_type] == 'ElectricResistance'
    args[:heating_system_fuel] = 'electricity'
  end
end

def residential_appliances(args)
  args[:cooking_range_oven_fuel_type] = args[:heating_system_fuel]
  args[:clothes_dryer_fuel_type] = args[:heating_system_fuel]
  args[:water_heater_fuel_type] = args[:heating_system_fuel]
end