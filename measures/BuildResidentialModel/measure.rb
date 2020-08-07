# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/measures/measure_writing_guide/

require 'openstudio'

require_relative '../../resources/hpxml-measures/BuildResidentialHPXML/resources/constants'

require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/hpxml'
require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/constants'

require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/constants'

# require gem for merge measures
# was able to harvest measure paths from primary osw for meta osw. Remove this once confirm that works
#require 'openstudio-model-articulation'
#require 'measures/merge_spaces_from_external_file/measure.rb'

resources_dir = File.absolute_path(File.join(File.dirname(__FILE__), 'resources'))
meta_measure_file = File.join(resources_dir, 'meta_measure.rb')
require File.join(File.dirname(meta_measure_file), File.basename(meta_measure_file, File.extname(meta_measure_file)))

# start the measure
class BuildResidentialModel < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    return 'Build Residential Model'
  end

  # human readable description
  def description
    return 'Builds the OpenStudio Model for an existing residential building.'
  end

  # human readable description of modeling approach
  def modeler_description
    return 'Builds the residential OpenStudio Model using the geojson feature file, which contains the specified parameters for each existing building.'
  end

  # define the arguments that the user will input
  def arguments(model)
    measures_dir = File.absolute_path(File.join(File.dirname(__FILE__), '../../resources/hpxml-measures'))
    measure_subdir = 'BuildResidentialHPXML'
    full_measure_path = File.join(measures_dir, measure_subdir, 'measure.rb')
    measure = get_measure_instance(full_measure_path)

    args = OpenStudio::Measure::OSArgumentVector.new
    measure.arguments(model).each do |arg|
      next if ['hpxml_path', 'weather_dir', 'schedules_output_path'].include? arg.name
      args << arg
    end

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    measures_dir = File.absolute_path(File.join(File.dirname(__FILE__), '../../resources/hpxml-measures'))
    full_measure_path = File.join(measures_dir, 'BuildResidentialHPXML', 'measure.rb')
    check_file_exists(full_measure_path, runner)
    measure = get_measure_instance(full_measure_path)
    args = measure.get_argument_values(runner, user_arguments)

    # Get file/dir paths
    resources_dir = File.absolute_path(File.join(File.dirname(__FILE__), 'resources'))
    workflow_json = File.join(resources_dir, 'measure-info.json')

    # Apply HPXML measures
    measures_dir = File.absolute_path(File.join(File.dirname(__FILE__), '../../resources/hpxml-measures'))

    # Check file/dir paths exist
    check_dir_exists(measures_dir, runner)

    # Optionals: get or remove
    args.keys.each do |arg|
      begin # TODO: how to check if arg is an optional or not?
        if args[arg].is_initialized
          args[arg] = args[arg].get
        else
          args.delete(arg)
        end
      rescue
      end
    end

    # TODO: if merging inside loop then move this code before the loop, may not be needed at all
    # when supporting mixed use or non unit spaces like corrodior, will not want this
    #model.getBuilding.remove
    #model.getShadowCalculation.remove
    #model.getSimulationControl.remove
    #model.getSite.remove
    #model.getTimestep.remove

    unit_models = []
    (1..args[:geometry_num_units]).to_a.each do |num_unit|
      unit_model = OpenStudio::Model::Model.new

      # BuildResidentialHPXML
      measure_subdir = 'BuildResidentialHPXML'

      measure_args = args.clone
      measures = {}
      measures[measure_subdir] = []
      measure_args[:hpxml_path] = File.expand_path('../out.xml')
      measure_args[:weather_dir] = File.expand_path('../../../../weather')
      measure_args[:software_program_used] = 'URBANopt'
      measure_args[:software_program_version] = '0.3.1'
      measure_args[:schedules_output_path] = '../schedules.csv'
      measure_args = Hash[measure_args.collect{ |k, v| [k.to_s, v] }]
      measures[measure_subdir] << measure_args

      # HPXMLtoOpenStudio
      measure_subdir = 'HPXMLtoOpenStudio'

      full_measure_path = File.join(measures_dir, measure_subdir, 'measure.rb')
      check_file_exists(full_measure_path, runner)

      measure_args = {}
      measures[measure_subdir] = []
      measure_args[:hpxml_path] = File.expand_path('../out.xml')
      measure_args[:weather_dir] = File.expand_path('../../../../weather')
      measure_args[:output_dir] = File.expand_path('..')
      measure_args[:debug] = true
      measure_args = Hash[measure_args.collect{ |k, v| [k.to_s, v] }]
      measures[measure_subdir] << measure_args
      if not apply_measures(measures_dir, measures, runner, unit_model, workflow_json, 'out.osw', true)
        return false
      end

      unit_dir = File.expand_path("../unit #{num_unit}")
      Dir.mkdir(unit_dir)
      FileUtils.cp(File.expand_path('../out.osw'), unit_dir)
      FileUtils.cp(File.expand_path('../out.xml'), unit_dir)
      FileUtils.cp(File.expand_path('../in.xml'), unit_dir)
      FileUtils.cp(File.expand_path('../in.osm'), unit_dir)

      # create building unit object to assign to spaces
      building_unit = OpenStudio::Model::BuildingUnit.new(unit_model)
      building_unit.setName("building_unit_#{num_unit}")

      # save modified copy of model for use with merge
      unit_model.getSpaces.sort.each do |space|
        space.setYOrigin(60 * (num_unit -1)) # meters
        space.setBuildingUnit(building_unit)
      end

      # prefix all objects with name using unit number. May be cleaner if source models are setup with unique names
      unit_model.objects.each do |model_object|
        next if model_object.name.nil?
        model_object.setName("unit_#{num_unit} #{model_object.name.to_s}")
      end

      moodified_unit_path = File.expand_path("../unit #{num_unit}/modified_unit.osm")
      unit_model.save(moodified_unit_path, true)

      # passing modified copy into array, can move earlier if we don't want the modified copy
      unit_models << unit_model


      # run merge merge_spaces_from_external_file to add this unit to original model
      merge_measures_dir = nil
      osw_measure_paths = runner.workflow.measurePaths
      osw_measure_paths.each do |orig_measure_path|
        next if not orig_measure_path.to_s.include?('gems/openstudio-model-articulation')
        merge_measures_dir = orig_measure_path.to_s
        break
      end
      merge_measure_subdir = 'merge_spaces_from_external_file'
      merge_measures = {}
      merge_measure_args = {}
      merge_measures[merge_measure_subdir] = []
      merge_measure_args[:external_model_name] = moodified_unit_path
      merge_measure_args[:merge_geometry] = true
      merge_measure_args[:merge_loads] = true
      merge_measure_args[:merge_attribute_names] = true
      merge_measure_args[:add_spaces] = true
      merge_measure_args[:remove_spaces] = false
      merge_measure_args[:merge_schedules] = true
      merge_measure_args[:compact_to_ruleset] = false
      merge_measure_args[:merge_zones] = true
      merge_measure_args[:merge_air_loops] = true
      merge_measure_args[:merge_plant_loops] = false # need to address control issue in E+ run
      merge_measure_args[:merge_swh] = true
      merge_measure_args = Hash[merge_measure_args.collect{ |k, v| [k.to_s, v] }]
      merge_measures[merge_measure_subdir] << merge_measure_args

      # for this instance pass in original model and not unit_model. unit_model path witll be an argument
      if not apply_measures(merge_measures_dir, merge_measures, runner, model, workflow_json, 'out.osw', true)
        return false
      end

    end

    # TODO: add surface intersection and matching (is don't in measure now but would be better to do once at end, make bool to skip in merge measure)

    return true
  end
end

# register the measure to be used by the application
BuildResidentialModel.new.registerWithApplication
