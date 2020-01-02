# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/measures/measure_writing_guide/

# start the measure
class BuildURBANoptModel < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    return "Build URBANopt Model"
  end

  # human readable description
  def description
    return "TODO"
  end

  # human readable description of modeling approach
  def modeler_description
    return "TODO"
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
    arg.setDescription("The number of stories of the residential building.")
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

    # TODO
    # call one of the whole building create geometry measures
    # loop thru resulting building units
    # call BuildResidentialHPXML, HPXMLtoOpenStudio
    # merge resulting models into one model

    return true
  end
end

# register the measure to be used by the application
BuildURBANoptModel.new.registerWithApplication
