# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-example-geojson-project/blob/develop/LICENSE.md
# *********************************************************************************

require 'csv'
require 'securerandom'

### Mapping methods from UO feature input names to buildstock characteristics names

def get_resstock_building_id(buildstock_csv_path, feature, building_type, logger)
  '''develop get_resstock_building_id method'''

  number_of_residential_units = 1
  begin
    number_of_residential_units = feature.number_of_residential_units
  rescue StandardError
  end

  mapped_properties = {}

  # Required properties to do the search
  begin
    mapped_properties['Geometry Building Type RECS'] = map_to_resstock_building_type(building_type, number_of_residential_units)
  rescue StandardError
  end

  # Conditionally add properties if they exist
  # number_of_stories_above_ground
  begin
    mapped_properties['Geometry Stories'] = feature.number_of_stories_above_ground
  rescue StandardError
    logger.info("\nnumber_of_stories_above_ground for feature #{feature.id} was not used to filter buildstok csv since it does not exist for this feature")
  end

  # number_of_residential_units SFA/MF
  begin
    mapped_properties['Geometry Building Number Units SFA'], mapped_properties['Geometry Building Number Units MF'] = map_to_resstock_num_units(building_type, number_of_residential_units)
  rescue StandardError
    logger.info("\nMF number_of_residential_units for feature #{feature.id} was not used to filter buildstock csv since it does not exist for this feature")
  end

  # year built
  begin
   mapped_properties['Vintage ACS'] = map_to_resstock_vintage(feature.year_built) # Assuming direct mapping or apply conversion if needed
  rescue StandardError
   logger.info("\nyear_built for feature #{feature.id} was not used to filter buildstock csv since it does not exist for this feature")
  end

  # floor_area
  begin
    mapped_properties['Geometry Floor Area'] = map_to_resstock_floor_area(feature.floor_area, number_of_residential_units)
  rescue StandardError
    logger.info("\nfloor_area for feature #{feature.id} was not used to filter buildstock csv since it does not exist for this feature")
  end

  # number_of_bedrooms
  begin
    mapped_properties['Bedrooms'] = feature.number_of_bedrooms / number_of_residential_units # Assuming direct mapping or apply conversion if needed
  rescue StandardError
    logger.info("\nnumber_of_bedrooms for feature #{feature.id} was not used to filter buildstock csv since it does not exist for this feature")
  end

  #puts "########### mapped_properties = #{mapped_properties}" ##for debugging

  selected_id, infos = get_selected_id(mapped_properties, buildstock_csv_path, feature.id)

  infos.each do |info|
    logger.info(info)
  end

  return selected_id
end

def get_selected_id(mapped_properties, buildstock_csv_path, feature_id)  
  # Find building matches
  matches = []
  infos = []

  # read CSV FILE
  CSV.foreach(buildstock_csv_path, headers: true) do |row|
    
    # find if it's a match using reduce
    is_match = mapped_properties.reduce(true) do |acc, (key, value)|
      current_match = row[key].to_s.strip.downcase == value.to_s.strip.downcase
      #puts "resstock = #{row[key].to_s.strip.downcase} :::::: uo_feature = #{value.to_s.strip.downcase}" ##for debugging
      acc && current_match
    end

    #puts "IS_MATCH = #{is_match}" #for debugging

    if is_match
      # "Building" is the building id header in buildstock csv
      matches << row['Building']
    end
  end

  ## check the matches we got and select from them
  case matches.size
  when 0
    infos << "\nFeature #{feature_id}: No matching buildstock building ID found. #{mapped_properties}"
    selected_id = 0
  when 1
    selected_id = matches.first
    infos << "\nFeature #{feature_id}: Matching buildstock building ID found: #{selected_id}. #{mapped_properties}"
  else
    selected_ids = matches.sample(1, random: Random.new(12345))
    selected_id = selected_ids[0]
    infos << "\nFeature #{feature_id}: Multiple matches found. Selected one buildstock building ID randomly: #{selected_id} from #{matches.size} matching buildings: #{matches}. #{mapped_properties}"
  end

  ### Log matching results to csv 
  # Path to your log CSV file
  log_csv_path = File.join(File.dirname(__FILE__), '../../../run/uo_buildstock_match_log.csv')

  full_path = File.join(Dir.pwd, log_csv_path)
  puts "CSV is saved at: #{full_path}"

  # Initialize CSV file with headers if it doesn't exist
  unless File.exist?(log_csv_path)
    CSV.open(log_csv_path, 'wb') do |csv|
      csv << ['uo_id', 'matches', 'selected_match']
    end
  end
  # Append data to matching data CSV file
  CSV.open(log_csv_path, 'ab') do |csv|
    # Convert matches array to a string to store in CSV
    matches_str = matches.join('; ')
    selected_match_str = selected_id.to_s # selected_id is the result of the case statement

    # Append new row with feature ID, matches, and selected match
    csv << [feature_id, matches_str, selected_match_str]
  end

  return selected_id, infos
end

def map_to_resstock_building_type(res_type, number_of_residential_units)
  '''Define function to map building type to categories'''
  
  if res_type == 'Multifamily'
    if number_of_residential_units >= 5
      return 'Multi-Family with 5+ Units'
    elsif number_of_residential_units.between?(2, 4)
      return 'Multi-Family with 2 - 4 Units'
    end              
  elsif res_type == 'Single-Family Attached'
    return 'Single-Family Attached'
  elsif res_type == 'Single-Family Detached'
    return 'Single-Family Detached'
  elsif res_type == 'Mobile Home'
    return 'Mobile Home'
  else 
    return 'Other Category'
  end

end

def map_to_resstock_floor_area(floor_area, number_of_residential_units)
  '''floor area mapping using "Geometry Floor Area" floor area'''

  floor_area_mapping = {
    '750-999' => [750, 999],
    '1000-1499' => [1000, 1499],
    '500-749' => [500, 749],
    '3000-3999' => [3000, 3999],
    '2000-2499' => [2000, 2499],
    '1500-1999' => [1500, 1999],
    '2500-2999' => [2500, 2999],
    '4000+' => [4000, Float::INFINITY],
    '0-499' => [0, 499]
  }
  resstock_floor_area = nil

  floor_area /= number_of_residential_units
  floor_area_mapping.each do |key, range|
    if floor_area >= range[0] && floor_area <= range[1]
      resstock_floor_area = key
      break # Exit the loop once the correct resstock floor area category is found
    end
  end
  return resstock_floor_area # Return resstock floor area category
end

def map_to_resstock_vintage(year_built)
  '''mapping to resstock Vintage ACS'''

  vintage_mapping = {
    '2000-09' => (2000..2009),
    '1940-59' => (1940..1959),
    '2010s'   => (2010..2019),
    '1980-99' => (1980..1999),
    '1960-79' => (1960..1979),
    '<1940'   => (..1939) 
  }

  resstock_vintage_ACS_category = nil

  vintage_mapping.each do |key, range|
    if range.cover?(year_built)
      resstock_vintage_ACS_category = key
      break # Exit the loop once the correct resstock vintage ACS category is found
    end
  end

  return resstock_vintage_ACS_category # Return resstock vintage ACS category
end

def map_to_resstock_num_units(res_type, number_of_residential_units)
  '''Define function to map "number_of_residential_units" to categories'''

  if res_type == 'Single-Family Detached'
    return 'None', 'None'
  elsif res_type == 'Single-Family Attached'
    return number_of_residential_units, 'None'
  elsif res_type == 'Multifamily'
    return 'None', number_of_residential_units
  end          
end

def find_building_for_uo_id(buildstock_csv_path, uo_buildstock_mapping_csv_path, feature)
  '''get buildstock building id from the uo_buildstock_mapping_csv'''
  '''Read csv file and find the resstock_building_id that correspond to the uo feature'''

  building_id = nil
  uo_id = feature.id
  CSV.foreach(uo_buildstock_mapping_csv_path, headers: true) do |row|
    if row['UO_id'].to_s == uo_id.to_s
      building_id = row['Building']
      break # Exit the loop once the matching building ID is found
    end
  end
  if building_id.nil?
    
  end
  return building_id # Returns the found building ID or nil if not found
end

def residential_samples(args, resstock_building_id, buildstock_csv_path)
  '''Assign resstock_building_id that points to buildstock_csv_path.'''

  args[:resstock_building_id] = resstock_building_id

  # Create lib folder (so we can more easily copy code from BuildExistingModel)
  res_measures_dir = File.absolute_path(File.join(File.dirname(__FILE__), '../../../resources/residential-measures'))
  lib_dir = File.join(res_measures_dir, 'lib')
  resources_dir = File.join(res_measures_dir, 'resources')
  housing_characteristics_dir = File.join(res_measures_dir, 'project_national/housing_characteristics')

  FileUtils.rm_rf(lib_dir)
  Dir.mkdir(lib_dir) if !File.exist?(lib_dir)
  FileUtils.cp_r(resources_dir, lib_dir)
  FileUtils.cp_r(housing_characteristics_dir, lib_dir)
  FileUtils.cp(buildstock_csv_path, File.join(housing_characteristics_dir, 'buildstock.csv'))
  sleep(1) # avoid Cannot find file /path/to/lib/housing_characteristics/buildstock.csv.
end    