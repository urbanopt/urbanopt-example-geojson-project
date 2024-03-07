# *********************************************************************************
# URBANopt (tm), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://github.com/urbanopt/urbanopt-example-geojson-project/blob/develop/LICENSE.md
# *********************************************************************************

# frozen_string_literal: true

require_relative '../../../resources/residential-measures/resources/hpxml-measures/HPXMLtoOpenStudio/resources/minitest_helper'
require_relative '../../../mappers/residential/util'
require_relative '../../../mappers/residential/template/util'
require_relative '../../../mappers/residential/samples/util'
require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require_relative '../measure.rb'
require 'csv'
require 'pathname'

class BuildResidentialModelTest < Minitest::Test
  def setup
    @tests_path = Pathname(__FILE__).dirname
    @run_path = @tests_path / 'run'
    FileUtils.mkdir_p(@run_path)
    @model_save = true # true helpful for debugging, i.e., save the HPXML files
  end

  def teardown
    FileUtils.rm_rf(@run_path) if !@model_save
  end

  def _initialize_arguments()
    @args = {}

    # BuildResidentialModel required arguments
    @args[:urbanopt_feature_id] = 1
    @args[:schedules_type] = 'stochastic'
    @args[:schedules_random_seed] = 1
    @args[:schedules_variation] = 'unit'
    @args[:geometry_num_floors_above_grade] = 1
    @args[:hpxml_path] = @hpxml_path.to_s
    @args[:output_dir] = File.dirname(@hpxml_path)

    # Optionals / Feature
    @args[:geometry_building_num_units] = 1
    @timestep = 60
    @run_period = 'Jan 1 - Dec 31'
    @calendar_year = 2007
    @weather_filename = 'USA_NY_Buffalo-Greater.Buffalo.Intl.AP.725280_TMY3.epw'
    @building_type = 'Single-Family Detached'
    @floor_area = 3055
    @number_of_bedrooms = 3
    @geometry_unit_orientation = nil
    @geometry_aspect_ratio = nil
    @occupancy_calculation_type = nil
    @number_of_occupants = nil
    @maximum_roof_height = 8.0
    @foundation_type = 'crawlspace - unvented'
    @attic_type = 'attic - vented'
    @roof_type = 'Gable'
    @onsite_parking_fraction = false
    @system_type = 'Residential - furnace and central air conditioner'
    @heating_system_fuel_type = 'natural gas'
  end

  def test_hpxml_dir
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "hpxml_directory"

    test_folder = @run_path / __method__.to_s

    @hpxml_path = test_folder / '' / 'feature.xml'
    puts @hpxml_path
    _initialize_arguments()
    @args[:hpxml_dir] = '18'
    _test_measure(expected_errors: ["HPXML directory 'xml_building/18' was specified for feature ID = 1, but could not be found."])

    @hpxml_path = test_folder / '' / 'feature.xml'
    _initialize_arguments()
    @args[:hpxml_dir] = '../measures/BuildResidentialModel/tests/xml_building/17'
    _test_measure(expected_errors: ["HPXML directory 'xml_building/17' must contain exactly 1 HPXML file; the single file can describe multiple dwelling units of a feature."])

    @hpxml_path = test_folder / '' / 'feature.xml'
    _initialize_arguments()
    @args[:hpxml_dir] = '17'
    _test_measure(expected_errors: ['The number of actual dwelling units (4) differs from the specified number of units (1).'])

    @hpxml_path = test_folder / '17' / 'feature.xml'
    FileUtils.mkdir_p(File.dirname(@hpxml_path))
    _initialize_arguments()
    @args[:hpxml_dir] = '17'
    @args[:geometry_building_num_units] = 4
    _test_measure()
  end

  def test_schedules_type
    # Baseline.rb mapper currently hardcodes schedules_type to "stochastic"

    schedules_types = ['stochastic', 'smooth']

    test_folder = @run_path / __method__.to_s
    schedules_types.each do |schedules_type|
      @hpxml_path = test_folder / "#{schedules_type}" / 'feature.xml'
      _initialize_arguments()

      @args[:schedules_type] = schedules_type

      _apply_residential()
      _test_measure()
    end
  end

  def test_feature_building_types_num_units_and_stories
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "number_of_residential_units"
    # - "number_of_stories_above_ground"

    feature_building_types = ['Single-Family Detached', 'Single-Family Attached', 'Multifamily']
    feature_number_of_residential_unitss = (1..3).to_a
    feature_number_of_stories_above_grounds = (1..2).to_a

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_number_of_residential_unitss.each do |feature_number_of_residential_units|
        feature_number_of_stories_above_grounds.each do |feature_number_of_stories_above_ground|
          @hpxml_path = test_folder / "#{feature_building_type}_#{feature_number_of_residential_units}_#{feature_number_of_stories_above_ground}" / 'feature.xml'
          _initialize_arguments()

          @building_type = feature_building_type
          @args[:geometry_num_floors_above_grade] = feature_number_of_stories_above_ground
          @args[:geometry_building_num_units] = feature_number_of_residential_units

          _apply_residential()
          _test_measure(expected_errors: [])
        end
      end
    end
  end

  def test_feature_building_foundation_and_attic_types_and_num_stories
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "foundationType"
    # - "atticType"
    # - "number_of_stories_above_ground"

    feature_building_types = ['Single-Family Detached', 'Single-Family Attached', 'Multifamily']
    feature_foundation_types = ['slab', 'crawlspace - vented', 'crawlspace - conditioned', 'basement - unconditioned',	'basement - conditioned', 'ambient']
    feature_attic_types = ['attic - vented', 'attic - conditioned', 'flat roof']
    feature_number_of_stories_above_grounds = (1..2).to_a

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_foundation_types.each do |feature_foundation_type|
        feature_attic_types.each do |feature_attic_type|
          feature_number_of_stories_above_grounds.each do |feature_number_of_stories_above_ground|
            @hpxml_path = test_folder / "#{feature_building_type}_#{feature_foundation_type}_#{feature_attic_type}_#{feature_number_of_stories_above_ground}" / 'feature.xml'
            _initialize_arguments()

            @building_type = feature_building_type
            @foundation_type = feature_foundation_type
            @attic_type = feature_attic_type
            @args[:geometry_num_floors_above_grade] = feature_number_of_stories_above_ground

            expected_errors = []
            if feature_attic_type == 'attic - conditioned' && feature_number_of_stories_above_ground == 1
              expected_errors += ['Units with a conditioned attic must have at least two above-grade floors.']
            end
            if feature_building_type == 'Multifamily' && ['basement - conditioned', 'crawlspace - conditioned'].include?(feature_foundation_type)
              expected_errors += ['Conditioned basement/crawlspace foundation type for apartment units is not currently supported.']
            end

            _apply_residential()
            _test_measure(expected_errors: expected_errors)
          end
        end
      end
    end
  end

  def test_feature_building_types_num_units_and_bedrooms
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "number_of_residential_units"
    # - "number_of_bedrooms"

    feature_building_types = ['Single-Family Detached', 'Multifamily']
    feature_number_of_residential_unitss = (2..4).to_a
    feature_number_of_bedroomss = (11..13).to_a

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_number_of_residential_unitss.each do |feature_number_of_residential_units|
        feature_number_of_bedroomss.each do |feature_number_of_bedrooms|
          @hpxml_path = test_folder / "#{feature_building_type}_#{feature_number_of_residential_units}_#{feature_number_of_bedrooms}" / 'feature.xml'
          _initialize_arguments()

          @building_type = feature_building_type
          @args[:geometry_building_num_units] = feature_number_of_residential_units
          @number_of_bedrooms = feature_number_of_bedrooms

          _apply_residential()
          _test_measure()
        end
      end
    end
  end

  def test_feature_building_occ_calc_types_num_occupants_and_units
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "occupancy_calculation_type"
    # - "number_of_residential_units"
    # - "number_of_occupants"

    feature_building_types = ['Single-Family Detached', 'Multifamily']
    feature_occupancy_calculation_types = ['asset', 'operational']
    feature_number_of_residential_unitss = (2..3).to_a
    feature_number_of_occupantss = [nil, 3]

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_occupancy_calculation_types.each do |feature_occupancy_calculation_type|
        feature_number_of_residential_unitss.each do |feature_number_of_residential_units|
          feature_number_of_occupantss.each do |feature_number_of_occupants|
            @hpxml_path = test_folder / "#{feature_building_type}_#{feature_occupancy_calculation_type}_#{feature_number_of_residential_units}_#{feature_number_of_occupants}" / 'feature.xml'
            _initialize_arguments()

            @building_type = feature_building_type
            @occupancy_calculation_type = feature_occupancy_calculation_type
            @args[:geometry_building_num_units] = feature_number_of_residential_units
            @number_of_occupants = feature_number_of_occupants

            _apply_residential()
            _test_measure()
          end
        end
      end
    end
  end

  def test_feature_building_foundation_types_and_garages
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "foundationType"
    # - "onsite_parking_fraction"

    feature_building_types = ['Single-Family Detached', 'Single-Family Attached', 'Multifamily']
    feature_foundation_types = ['slab', 'crawlspace - vented', 'crawlspace - conditioned', 'basement - unconditioned',	'basement - conditioned', 'ambient']
    feature_onsite_parking_fractions = [false, true]

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_foundation_types.each do |feature_foundation_type|
        feature_onsite_parking_fractions.each do |feature_onsite_parking_fraction|
          @hpxml_path = test_folder / "#{feature_building_type}_#{feature_foundation_type}_#{feature_onsite_parking_fraction}" / 'feature.xml'
          _initialize_arguments()

          @building_type = feature_building_type
          @foundation_type = feature_foundation_type
          @onsite_parking_fraction = feature_onsite_parking_fraction
          @args[:geometry_building_num_units] = 2

          expected_errors = []
          if feature_foundation_type == 'ambient' && feature_onsite_parking_fraction
            expected_errors += ['Cannot handle garages with an ambient foundation type.']
          end
          if feature_building_type == 'Multifamily' && ['basement - conditioned', 'crawlspace - conditioned'].include?(feature_foundation_type)
            expected_errors += ['Conditioned basement/crawlspace foundation type for apartment units is not currently supported.']
          end

          _apply_residential()
          _test_measure(expected_errors: expected_errors)
        end
      end
    end
  end

  def test_hvac_system_and_fuel_types
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "systemType" (those prefixed with "Residential")
    # - "heatingSystemFuelType"

    feature_system_types = ['Residential - electric resistance and no cooling', 'Residential - electric resistance and central air conditioner',	'Residential - electric resistance and room air conditioner', 'Residential - electric resistance and evaporative cooler', 'Residential - furnace and no cooling', 'Residential - furnace and central air conditioner', 'Residential - furnace and room air conditioner', 'Residential - furnace and evaporative cooler', 'Residential - boiler and no cooling', 'Residential - boiler and central air conditioner', 'Residential - boiler and room air conditioner', 'Residential - boiler and evaporative cooler', 'Residential - air-to-air heat pump', 'Residential - mini-split heat pump', 'Residential - ground-to-air heat pump']
    feature_heating_system_fuel_types = ['electricity', 'natural gas', 'fuel oil', 'propane', 'wood']

    test_folder = @run_path / __method__.to_s
    feature_system_types.each do |feature_system_type|
      feature_heating_system_fuel_types.each do |feature_heating_system_fuel_type|
        @hpxml_path = test_folder / "#{feature_system_type}_#{feature_heating_system_fuel_type}" / 'feature.xml'
        _initialize_arguments()
        
        @system_type = feature_system_type
        @heating_system_fuel_type = feature_heating_system_fuel_type

        _apply_residential()
        _test_measure()
      end
    end
  end

  def test_residential_templates
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "templateType"

    feature_templates = ['Residential IECC 2006 - Customizable Template Sep 2020', 'Residential IECC 2009 - Customizable Template Sep 2020', 'Residential IECC 2012 - Customizable Template Sep 2020', 'Residential IECC 2015 - Customizable Template Sep 2020', 'Residential IECC 2018 - Customizable Template Sep 2020', 'Residential IECC 2006 - Customizable Template Apr 2022', 'Residential IECC 2009 - Customizable Template Apr 2022', 'Residential IECC 2012 - Customizable Template Apr 2022', 'Residential IECC 2015 - Customizable Template Apr 2022', 'Residential IECC 2018 - Customizable Template Apr 2022']
    climate_zones = ['1B', '5A']

    test_folder = @run_path / __method__.to_s
    feature_templates.each do |feature_template|
      climate_zones.each do |climate_zone|
        @hpxml_path = test_folder / "#{feature_template}_#{climate_zone}" / 'feature.xml'
        _initialize_arguments()

        @template = feature_template
        @climate_zone = climate_zone

        _apply_residential()
        _apply_residential_template()
        _test_measure()
      end
    end
  end

  def test_residential_samples
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "number_of_residential_units"
    # - "floor_area"
    # - "number_of_bedrooms"
    # - "characterize_residential_buildings_from_buildstock_csv"
    # - "resstock_buildstock_csv_path"

    FileUtils.mkdir_p(File.join(File.dirname(__FILE__), '../../../run'))

    @buildstock_csv_path = File.absolute_path(File.join(File.dirname(__FILE__), '../../../resources/residential-measures/test/base_results/baseline/annual/buildstock.csv'))
    @number_of_stories_above_ground = nil
    @year_built = nil

    feature_building_types = ['Single-Family Detached', 'Single-Family Attached', 'Multifamily']
    feature_number_of_residential_unitss = [1, 5, 7]
    feature_floor_areas = [5000, 9000]

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_number_of_residential_unitss.each do |feature_number_of_residential_units|
        feature_floor_areas.each do |feature_floor_area|
          @hpxml_path = test_folder / "#{feature_building_type}_#{feature_number_of_residential_units}_#{feature_floor_area}" / 'feature.xml'
          _initialize_arguments()

          @building_type = feature_building_type          
          @number_of_residential_units = feature_number_of_residential_units
          @floor_area = feature_floor_area
          @number_of_bedrooms = 2 * @number_of_residential_units

          # Skip
          next if @building_type == 'Single-Family Detached' && @number_of_residential_units > 1

          expected_errors = []
          if ['Single-Family Attached', 'Multifamily'].include?(@building_type) && @number_of_residential_units == 1
            expected_errors = ['Feature ID = 1: No matching buildstock building ID found.']
          end

          _apply_residential()
          _apply_residential_samples()
          _test_measure(expected_errors: expected_errors)
        end
      end
    end
  end

  def test_residential_samples2
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "buildingType"
    # - "number_of_residential_units"
    # - "number_of_stories_above_ground"
    # - "year_built"
    # - "number_of_bedrooms"
    # - "characterize_residential_buildings_from_buildstock_csv"
    # - "resstock_buildstock_csv_path"

    FileUtils.mkdir_p(File.join(File.dirname(__FILE__), '../../../run'))

    @buildstock_csv_path = File.absolute_path(File.join(File.dirname(__FILE__), '../../../resources/residential-measures/test/base_results/baseline/annual/buildstock.csv'))
    @number_of_residential_units = 8

    feature_number_of_stories_above_grounds = [2, 3]
    feature_year_builts = [1967, 1985]
    feature_number_of_bedroomss = [8, 16]

    test_folder = @run_path / __method__.to_s
    feature_number_of_stories_above_grounds.each do |feature_number_of_stories_above_ground|
      feature_year_builts.each do |feature_year_built|
        feature_number_of_bedroomss.each do |feature_number_of_bedrooms|
          @hpxml_path = test_folder / "#{feature_number_of_stories_above_ground}_#{feature_year_built}_#{feature_number_of_bedrooms}" / 'feature.xml'
          _initialize_arguments()

          @building_type = 'Multifamily'
          @floor_area = 505 * @number_of_residential_units
          @number_of_stories_above_ground = feature_number_of_stories_above_ground          
          @year_built = feature_year_built
          @number_of_bedrooms = feature_number_of_bedrooms

          expected_errors = []
          if ( @number_of_stories_above_ground == 3 && @year_built == 1967 && @number_of_bedrooms == 16 ) ||
             ( @number_of_stories_above_ground == 3 && @year_built == 1985 )
            expected_errors = ['Feature ID = 1: No matching buildstock building ID found.']
          end

          _apply_residential()
          _apply_residential_samples()
          _test_measure(expected_errors: expected_errors)
        end
      end
    end
  end

  def test_residential_samples3
    # in https://github.com/urbanopt/urbanopt-geojson-gem/blob/develop/lib/urbanopt/geojson/schema/building_properties.json, see:
    # - "characterize_residential_buildings_from_buildstock_csv"
    # - "uo_buildstock_mapping_csv_path"

    FileUtils.mkdir_p(File.join(File.dirname(__FILE__), '../../../run'))

    @buildstock_csv_path = File.absolute_path(File.join(File.dirname(__FILE__), '../../../resources/residential-measures/test/base_results/baseline/annual/buildstock.csv'))
    @uo_buildstock_mapping_csv_path = File.absolute_path(File.join(File.dirname(__FILE__), '../../../resources/uo_buildstock_mapping.csv'))

    feature_ids = ['14', '15', '16']

    test_folder = @run_path / __method__.to_s
    feature_ids.each do |feature_id|
      @hpxml_path = test_folder / "#{feature_id}" / 'feature.xml'
      _initialize_arguments()

      _apply_residential()
      resstock_building_id = find_building_for_uo_id(@uo_buildstock_mapping_csv_path, feature_id)
      residential_samples(@args, resstock_building_id, @buildstock_csv_path)
      _test_measure(expected_errors: [])
    end
  end

  def test_multifamily_one_unit_per_floor
    feature_building_types = ['Multifamily']
    feature_number_of_residential_unitss = (1..5).to_a

    test_folder = @run_path / __method__.to_s
    feature_building_types.each do |feature_building_type|
      feature_number_of_residential_unitss.each do |feature_number_of_residential_units|
        @hpxml_path = test_folder / "#{feature_building_type}_#{feature_number_of_residential_units}" / 'feature.xml'
        _initialize_arguments()
        
        @building_type = feature_building_type
        @args[:geometry_building_num_units] = feature_number_of_residential_units
        @args[:geometry_num_floors_above_grade] = feature_number_of_residential_units
        @number_of_bedrooms *= feature_number_of_residential_units
        @maximum_roof_height *= @args[:geometry_num_floors_above_grade]

        _apply_residential()
        _test_measure()
      end
    end
  end

  def _apply_residential()
    residential_simulation(@args, @timestep, @run_period, @calendar_year, @weather_filename)
    residential_geometry_unit(@args, @building_type, @floor_area, @number_of_bedrooms, @geometry_unit_orientation, @geometry_unit_aspect_ratio, @occupancy_calculation_type, @number_of_occupants, @maximum_roof_height)
    residential_geometry_foundation(@args, @foundation_type)
    residential_geometry_attic(@args, @attic_type, @roof_type)
    residential_geometry_garage(@args, @onsite_parking_fraction)
    residential_geometry_neighbor(@args)
    residential_hvac(@args, @system_type, @heating_system_fuel_type)
    residential_appliances(@args)
  end

  def _apply_residential_template()
    residential_template(@args, @template, @climate_zone)
  end

  def _apply_residential_samples()
    mapped_properties = {}
    mapped_properties['Geometry Building Type RECS'] = map_to_resstock_building_type(@building_type, @number_of_residential_units)
    mapped_properties['Geometry Stories'] = @number_of_stories_above_ground if !@number_of_stories_above_ground.nil?
    mapped_properties['Geometry Building Number Units SFA'], mapped_properties['Geometry Building Number Units MF'] = map_to_resstock_num_units(@building_type, @number_of_residential_units) if !@number_of_residential_units.nil?
    mapped_properties['Vintage ACS'] = map_to_resstock_vintage(@year_built) if !@year_built.nil?
    mapped_properties['Geometry Floor Area'] = map_to_resstock_floor_area(@floor_area, @number_of_residential_units) if !@floor_area.nil?
    mapped_properties['Bedrooms'] = @number_of_bedrooms / @number_of_residential_units if !@number_of_bedrooms.nil?
    resstock_building_id, infos = get_selected_id(mapped_properties, @buildstock_csv_path, @args[:urbanopt_feature_id])
    puts infos.join
    residential_samples(@args, resstock_building_id, @buildstock_csv_path)
  end

  def _test_measure(expected_errors: [])
    # create an instance of the measure
    measure = BuildResidentialModel.new

    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)
    model = OpenStudio::Model::Model.new

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if @args.has_key?(arg.name.to_sym)
        assert(temp_arg_var.setValue(@args[arg.name.to_sym]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # assert that it ran correctly
    if !expected_errors.empty?
      # show_output(result) unless result.value.valueName == 'Fail'
      assert_equal('Fail', result.value.valueName)

      error_msgs = result.errors.map { |x| x.logMessage }
      expected_errors.each do |expected_error|
        assert_includes(error_msgs, expected_error)
      end
    else
      show_output(result) unless result.value.valueName == 'Success'
      assert_equal('Success', result.value.valueName)
    end
  end
end
