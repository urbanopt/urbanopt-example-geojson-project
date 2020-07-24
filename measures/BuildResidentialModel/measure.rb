# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/measures/measure_writing_guide/

require 'openstudio'

require_relative '../../resources/hpxml-measures/BuildResidentialHPXML/resources/constants'

require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/hpxml'
require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/constants'

require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/constants'

# require gem for merge measure
#require 'openstudio-model-articulation'
#require 'openstudio-model-articulation/lib/measures'

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

      unit_models << unit_model
    end

    # TODO: if merging inside loop then move this code before the loop
    model.getBuilding.remove
    model.getShadowCalculation.remove
    model.getSimulationControl.remove
    model.getSite.remove
    model.getTimestep.remove

    # TODO: merge will be moved inside loop where unit_models is populated, may not need that array unless for diagnostics?
    unit_models.each do |unit_model|
      model.addObjects(unit_model.objects, true)
    end

    # TODO: add ideal loads until replace with full hvac, may need to create place holder thermostat as well.

    return true
  end
end

# register the measure to be used by the application
BuildResidentialModel.new.registerWithApplication
