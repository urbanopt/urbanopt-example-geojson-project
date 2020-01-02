# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/measures/measure_writing_guide/

require 'openstudio'

# start the measure
class BuildURBANoptModel < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    return "Build URBANopt Model"
  end

  # human readable description
  def description
    return "Builds the OpenStudio Model for an existing building."
  end

  # human readable description of modeling approach
  def modeler_description
    return "Builds the OpenStudio Model using the geojson feature file, which contains the specified parameters for each existing building."
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    arg = OpenStudio::Ruleset::OSArgument.makeStringArgument("building_type", true)
    arg.setDisplayName("Building Type")
    arg.setDescription("The type of the residential building.")
    args << arg

    arg = OpenStudio::Ruleset::OSArgument.makeDoubleArgument("footprint_area", true)
    arg.setDisplayName("Footpring Area")
    arg.setDescription("The footprint area of the residential building.")
    args << arg

    arg = OpenStudio::Ruleset::OSArgument.makeIntegerArgument("number_of_stories", true)
    arg.setDisplayName("Number of Stories")
    arg.setDescription("The number of stories in the residential building.")
    args << arg

    arg = OpenStudio::Ruleset::OSArgument.makeIntegerArgument("number_of_residential_units", true)
    arg.setDisplayName("Number of Residential Units")
    arg.setDescription("The number of residential units in the residential building.")
    args << arg

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    building_type = runner.getStringArgumentValue("building_type", user_arguments)
    footprint_area = runner.getDoubleArgumentValue("footprint_area", user_arguments)
    number_of_stories = runner.getIntegerArgumentValue("number_of_stories", user_arguments)
    number_of_residential_units = runner.getIntegerArgumentValue("number_of_residential_units", user_arguments)

    # Calculate
    unit_ffa = footprint_area * number_of_stories / number_of_residential_units

    # Get file/dir paths
    resources_dir = File.absolute_path(File.join(File.dirname(__FILE__), "../../model-measures/HPXMLtoOpenStudio/resources"))
    meta_measure_file = File.join(resources_dir, "meta_measure.rb")
    require File.join(File.dirname(meta_measure_file), File.basename(meta_measure_file, File.extname(meta_measure_file)))
    measures_dir = "C:/OpenStudio/OpenStudio-BuildStock-master/resources/measures"

    # Check file/dir paths exist
    check_dir_exists(measures_dir, runner)

    # Choose which whole building create geometry measure to call
    if building_type == "single-family detached"
      measure_subdir = "ResidentialGeometryCreateSingleFamilyDetached"
    elsif building_type == "single-family attached"
      measure_subdir = "ResidentialGeometryCreateSingleFamilyAttached"
    elsif building_type == "multifamily"
      measure_subdir = "ResidentialGeometryCreateMultifamily"
    end

    full_measure_path = File.join(measures_dir, measure_subdir, "measure.rb")
    check_file_exists(full_measure_path, runner)
    measure = get_measure_instance(full_measure_path)

    # Fill the measure args hash with default values
    args = get_measure_args_default_values(model, measure)

    # Override some defaults with geojson feature file values
    measures = {}
    measures[measure_subdir] = [args]
    if building_type == "single-family detached"
      measures[measure_subdir][0]["total_ffa"] = "#{unit_ffa}"
      measures[measure_subdir][0]["num_floors"] = "#{number_of_stories}"
    elsif ["single-family attached", "multifamily"].include? building_type
      measures[measure_subdir][0]["unit_ffa"] = "#{unit_ffa}"
      measures[measure_subdir][0]["num_floors"] = "#{number_of_stories}"
      measures[measure_subdir][0]["num_units"] = "#{number_of_residential_units}"
    end

    if not apply_measures(measures_dir, measures, runner, model, true)
      return false
    end

    # Now apply HPXML measures to each building unit
    measures_dir = "C:/urbanopt/urbanopt-example-geojson-project/model-measures"

    # Check file/dir paths exist
    check_dir_exists(measures_dir, runner)

    unit_models = []
    model.getBuildingUnits.each do |unit|
      unit_model = OpenStudio::Model::Model.new

      # BuildResidentialHPXML
      measure_subdir = "BuildResidentialHPXML"
      full_measure_path = File.join(measures_dir, measure_subdir, "measure.rb")
      check_file_exists(full_measure_path, runner)
      measure = get_measure_instance(full_measure_path)

      # Fill the measure args hash with default values
      args = get_measure_args_default_values(model, measure)

      measures = {}
      measures[measure_subdir] = [args]
      measures[measure_subdir][0]["weather_station_epw_filename"] = "USA_CO_Denver.Intl.AP.725650_TMY3.epw"
      measures[measure_subdir][0]["hpxml_output_path"] = "../in.xml"
      measures[measure_subdir][0]["schedules_output_path"] = "../schedules.csv"
      measures[measure_subdir][0]["unit_type"] = building_type
      measures[measure_subdir][0]["cfa"] = unit_ffa

      if not apply_measures(measures_dir, measures, runner, unit_model, true)
        return false
      end

      # HPXMLtoOpenStudio
      measure_subdir = "HPXMLtoOpenStudio"
      full_measure_path = File.join(measures_dir, measure_subdir, "measure.rb")
      check_file_exists(full_measure_path, runner)
      measure = get_measure_instance(full_measure_path)

      # Fill the measure args hash with default values
      args = get_measure_args_default_values(model, measure)

      measures = {}
      measures[measure_subdir] = [args]
      measures[measure_subdir][0]["hpxml_path"] = "../in.xml"

      if not apply_measures(measures_dir, measures, runner, unit_model, true)
        return false
      end

      unit_models << unit_model
    end

    # TODO: Merge all the individual unit models into one model
  
    return true
  end

  def get_measure_args_default_values(model, measure)
    args = {}    
    measure_args = measure.arguments(model)
    measure_args.each do |arg|
      next unless arg.hasDefaultValue

      case arg.type.valueName.downcase
      when "boolean"
        args[arg.name] = "#{arg.defaultValueAsBool}"
      when "double"
        args[arg.name] = "#{arg.defaultValueAsDouble}"
      when "integer"
        args[arg.name] = "#{arg.defaultValueAsInteger}"
      when "string"
        args[arg.name] = "#{arg.defaultValueAsString}"
      when "choice"
        args[arg.name] = "#{arg.defaultValueAsString}"
      end
    end

    return args
  end
end

# register the measure to be used by the application
BuildURBANoptModel.new.registerWithApplication
