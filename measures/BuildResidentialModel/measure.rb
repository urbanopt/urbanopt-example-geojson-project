# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/measures/measure_writing_guide/

require 'openstudio'

require_relative '../../resources/hpxml-measures/BuildResidentialHPXML/resources/constants'

require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/hpxml'
require_relative '../../resources/hpxml-measures/HPXMLtoOpenStudio/resources/constants'

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
    args = OpenStudio::Measure::OSArgumentVector.new

    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('simulation_control_timestep', false)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('simulation_control_begin_month', false)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('simulation_control_begin_day_of_month', false)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('simulation_control_end_month', false)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('simulation_control_end_day_of_month', false)
    args << OpenStudio::Measure::OSArgument.makeStringArgument('weather_station_epw_filepath', true)

    site_type_choices = OpenStudio::StringVector.new
    site_type_choices << HPXML::SiteTypeSuburban
    site_type_choices << HPXML::SiteTypeUrban
    site_type_choices << HPXML::SiteTypeRural

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('site_type', site_type_choices, true)

    unit_type_choices = OpenStudio::StringVector.new
    unit_type_choices << HPXML::ResidentialTypeSFD
    unit_type_choices << HPXML::ResidentialTypeSFA
    unit_type_choices << HPXML::ResidentialTypeMF

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_unit_type', unit_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('geometry_num_units', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_cfa', true)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('geometry_num_floors_above_grade', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_wall_height', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_orientation', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_aspect_ratio', true)

    level_choices = OpenStudio::StringVector.new
    level_choices << 'Bottom'
    level_choices << 'Middle'
    level_choices << 'Top'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_level', level_choices, true)

    horizontal_location_choices = OpenStudio::StringVector.new
    horizontal_location_choices << 'Left'
    horizontal_location_choices << 'Middle'
    horizontal_location_choices << 'Right'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_horizontal_location', horizontal_location_choices, true)

    corridor_position_choices = OpenStudio::StringVector.new
    corridor_position_choices << 'Double-Loaded Interior'
    corridor_position_choices << 'Single Exterior (Front)'
    corridor_position_choices << 'Double Exterior'
    corridor_position_choices << 'None'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_corridor_position', corridor_position_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_corridor_width', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_inset_width', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_inset_depth', true)

    inset_position_choices = OpenStudio::StringVector.new
    inset_position_choices << 'Right'
    inset_position_choices << 'Left'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_inset_position', inset_position_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_balcony_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_garage_width', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_garage_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_garage_protrusion', true)

    garage_position_choices = OpenStudio::StringVector.new
    garage_position_choices << 'Right'
    garage_position_choices << 'Left'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_garage_position', garage_position_choices, true)

    foundation_type_choices = OpenStudio::StringVector.new
    foundation_type_choices << HPXML::FoundationTypeSlab
    foundation_type_choices << HPXML::FoundationTypeCrawlspaceVented
    foundation_type_choices << HPXML::FoundationTypeCrawlspaceUnvented
    foundation_type_choices << HPXML::FoundationTypeBasementUnconditioned
    foundation_type_choices << HPXML::FoundationTypeBasementConditioned
    foundation_type_choices << HPXML::FoundationTypeAmbient

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_foundation_type', foundation_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_foundation_height', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_foundation_height_above_grade', true)

    roof_type_choices = OpenStudio::StringVector.new
    roof_type_choices << 'gable'
    roof_type_choices << 'hip'
    roof_type_choices << 'flat'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_roof_type', roof_type_choices, true)

    roof_pitch_choices = OpenStudio::StringVector.new
    roof_pitch_choices << '1:12'
    roof_pitch_choices << '2:12'
    roof_pitch_choices << '3:12'
    roof_pitch_choices << '4:12'
    roof_pitch_choices << '5:12'
    roof_pitch_choices << '6:12'
    roof_pitch_choices << '7:12'
    roof_pitch_choices << '8:12'
    roof_pitch_choices << '9:12'
    roof_pitch_choices << '10:12'
    roof_pitch_choices << '11:12'
    roof_pitch_choices << '12:12'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_roof_pitch', roof_pitch_choices, true)

    roof_structure_choices = OpenStudio::StringVector.new
    roof_structure_choices << 'truss, cantilever'
    roof_structure_choices << 'rafter'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_roof_structure', roof_structure_choices, true)

    attic_type_choices = OpenStudio::StringVector.new
    attic_type_choices << HPXML::AtticTypeVented
    attic_type_choices << HPXML::AtticTypeUnvented
    attic_type_choices << HPXML::AtticTypeConditioned

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry_attic_type', attic_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('geometry_eaves_depth', true)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('geometry_num_bedrooms', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('geometry_num_bathrooms', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('geometry_num_occupants', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('floor_assembly_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('foundation_wall_insulation_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('foundation_wall_insulation_distance_to_top', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('foundation_wall_insulation_distance_to_bottom', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('foundation_wall_assembly_r', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('slab_perimeter_insulation_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('slab_perimeter_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('slab_under_insulation_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('slab_under_width', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('slab_carpet_fraction', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('slab_carpet_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ceiling_assembly_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('roof_assembly_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('roof_solar_absorptance', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('roof_emittance', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('roof_radiant_barrier', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('neighbor_front_distance', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('neighbor_back_distance', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('neighbor_left_distance', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('neighbor_right_distance', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('neighbor_front_height', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('neighbor_back_height', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('neighbor_left_height', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('neighbor_right_height', true)

    wall_type_choices = OpenStudio::StringVector.new
    wall_type_choices << HPXML::WallTypeWoodStud
    wall_type_choices << HPXML::WallTypeCMU
    wall_type_choices << HPXML::WallTypeDoubleWoodStud
    wall_type_choices << HPXML::WallTypeICF
    wall_type_choices << HPXML::WallTypeLog
    wall_type_choices << HPXML::WallTypeSIP
    wall_type_choices << HPXML::WallTypeConcrete
    wall_type_choices << HPXML::WallTypeSteelStud
    wall_type_choices << HPXML::WallTypeStone
    wall_type_choices << HPXML::WallTypeStrawBale
    wall_type_choices << HPXML::WallTypeBrick

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('wall_type', wall_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('wall_assembly_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('wall_solar_absorptance', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('wall_emittance', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_front_wwr', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_back_wwr', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_left_wwr', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_right_wwr', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_area_front', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_area_back', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_area_left', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_area_right', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_aspect_ratio', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_fraction_operable', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_ufactor', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_shgc', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_interior_shading_winter', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('window_interior_shading_summer', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_front_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_front_distance_to_top_of_window', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_back_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_back_distance_to_top_of_window', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_left_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_left_distance_to_top_of_window', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_right_depth', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('overhangs_right_distance_to_top_of_window', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('skylight_area_front', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('skylight_area_back', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('skylight_area_left', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('skylight_area_right', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('skylight_ufactor', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('skylight_shgc', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('door_area', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('door_rvalue', true)

    air_leakage_units_choices = OpenStudio::StringVector.new
    air_leakage_units_choices << HPXML::UnitsACH50
    air_leakage_units_choices << HPXML::UnitsCFM50
    air_leakage_units_choices << HPXML::UnitsACHNatural

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('air_leakage_units', air_leakage_units_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('air_leakage_value', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('air_leakage_shelter_coefficient', true)

    heating_system_type_choices = OpenStudio::StringVector.new
    heating_system_type_choices << 'none'
    heating_system_type_choices << HPXML::HVACTypeFurnace
    heating_system_type_choices << HPXML::HVACTypeWallFurnace
    heating_system_type_choices << HPXML::HVACTypeFloorFurnace
    heating_system_type_choices << HPXML::HVACTypeBoiler
    heating_system_type_choices << HPXML::HVACTypeElectricResistance
    heating_system_type_choices << HPXML::HVACTypeStove
    heating_system_type_choices << HPXML::HVACTypePortableHeater
    heating_system_type_choices << HPXML::HVACTypeFireplace

    heating_system_fuel_choices = OpenStudio::StringVector.new
    heating_system_fuel_choices << HPXML::FuelTypeElectricity
    heating_system_fuel_choices << HPXML::FuelTypeNaturalGas
    heating_system_fuel_choices << HPXML::FuelTypeOil
    heating_system_fuel_choices << HPXML::FuelTypePropane
    heating_system_fuel_choices << HPXML::FuelTypeWood
    heating_system_fuel_choices << HPXML::FuelTypeWoodPellets

    cooling_system_type_choices = OpenStudio::StringVector.new
    cooling_system_type_choices << 'none'
    cooling_system_type_choices << HPXML::HVACTypeCentralAirConditioner
    cooling_system_type_choices << HPXML::HVACTypeRoomAirConditioner
    cooling_system_type_choices << HPXML::HVACTypeEvaporativeCooler

    compressor_type_choices = OpenStudio::StringVector.new
    compressor_type_choices << HPXML::HVACCompressorTypeSingleStage
    compressor_type_choices << HPXML::HVACCompressorTypeTwoStage
    compressor_type_choices << HPXML::HVACCompressorTypeVariableSpeed

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('heating_system_type', heating_system_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('heating_system_fuel', heating_system_fuel_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heating_system_heating_efficiency_afue', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heating_system_heating_efficiency_percent', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('heating_system_heating_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heating_system_fraction_heat_load_served', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heating_system_electric_auxiliary_energy', false)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('cooling_system_type', cooling_system_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('cooling_system_cooling_efficiency_seer', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('cooling_system_cooling_efficiency_eer', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('cooling_system_cooling_compressor_type', compressor_type_choices, false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('cooling_system_cooling_sensible_heat_fraction', false)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('cooling_system_cooling_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('cooling_system_fraction_cool_load_served', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('cooling_system_evap_cooler_is_ducted', true)

    heat_pump_type_choices = OpenStudio::StringVector.new
    heat_pump_type_choices << 'none'
    heat_pump_type_choices << HPXML::HVACTypeHeatPumpAirToAir
    heat_pump_type_choices << HPXML::HVACTypeHeatPumpMiniSplit
    heat_pump_type_choices << HPXML::HVACTypeHeatPumpGroundToAir

    heat_pump_fuel_choices = OpenStudio::StringVector.new
    heat_pump_fuel_choices << HPXML::FuelTypeElectricity

    heat_pump_backup_fuel_choices = OpenStudio::StringVector.new
    heat_pump_backup_fuel_choices << 'none'
    heat_pump_backup_fuel_choices << HPXML::FuelTypeElectricity
    heat_pump_backup_fuel_choices << HPXML::FuelTypeNaturalGas
    heat_pump_backup_fuel_choices << HPXML::FuelTypeOil
    heat_pump_backup_fuel_choices << HPXML::FuelTypePropane

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('heat_pump_type', heat_pump_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_heating_efficiency_hspf', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_heating_efficiency_cop', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_cooling_efficiency_seer', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_cooling_efficiency_eer', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('heat_pump_cooling_compressor_type', compressor_type_choices, false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_cooling_sensible_heat_fraction', false)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('heat_pump_heating_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('heat_pump_heating_capacity_17F', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('heat_pump_cooling_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_fraction_heat_load_served', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_fraction_cool_load_served', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('heat_pump_backup_fuel', heat_pump_backup_fuel_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_backup_heating_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('heat_pump_backup_heating_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('heat_pump_backup_heating_switchover_temp', false)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('heat_pump_mini_split_is_ducted', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_heating_temp', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_heating_setback_temp', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_heating_setback_hours_per_week', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_heating_setback_start_hour', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_cooling_temp', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_cooling_setup_temp', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_cooling_setup_hours_per_week', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('setpoint_cooling_setup_start_hour', true)

    duct_leakage_units_choices = OpenStudio::StringVector.new
    duct_leakage_units_choices << HPXML::UnitsCFM25
    duct_leakage_units_choices << HPXML::UnitsPercent

    duct_location_choices = OpenStudio::StringVector.new
    duct_location_choices << Constants.Auto
    duct_location_choices << HPXML::LocationLivingSpace
    duct_location_choices << HPXML::LocationBasementConditioned
    duct_location_choices << HPXML::LocationBasementUnconditioned
    duct_location_choices << HPXML::LocationCrawlspaceVented
    duct_location_choices << HPXML::LocationCrawlspaceUnvented
    duct_location_choices << HPXML::LocationAtticVented
    duct_location_choices << HPXML::LocationAtticUnvented
    duct_location_choices << HPXML::LocationGarage
    duct_location_choices << HPXML::LocationOutside
    duct_location_choices << HPXML::LocationUnderSlab

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('ducts_supply_leakage_units', duct_leakage_units_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('ducts_return_leakage_units', duct_leakage_units_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ducts_supply_leakage_value', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ducts_return_leakage_value', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ducts_supply_insulation_r', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ducts_return_insulation_r', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('ducts_supply_location', duct_location_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('ducts_return_location', duct_location_choices, true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('ducts_supply_surface_area', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('ducts_return_surface_area', true)

    mech_vent_fan_type_choices = OpenStudio::StringVector.new
    mech_vent_fan_type_choices << 'none'
    mech_vent_fan_type_choices << HPXML::MechVentTypeExhaust
    mech_vent_fan_type_choices << HPXML::MechVentTypeSupply
    mech_vent_fan_type_choices << HPXML::MechVentTypeERV
    mech_vent_fan_type_choices << HPXML::MechVentTypeHRV
    mech_vent_fan_type_choices << HPXML::MechVentTypeBalanced
    mech_vent_fan_type_choices << HPXML::MechVentTypeCFIS

    mech_vent_recovery_efficiency_type_choices = OpenStudio::StringVector.new
    mech_vent_recovery_efficiency_type_choices << 'Unadjusted'
    mech_vent_recovery_efficiency_type_choices << 'Adjusted'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('mech_vent_fan_type', mech_vent_fan_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('mech_vent_flow_rate', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('mech_vent_hours_in_operation', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('mech_vent_total_recovery_efficiency_type', mech_vent_recovery_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('mech_vent_total_recovery_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('mech_vent_sensible_recovery_efficiency_type', mech_vent_recovery_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('mech_vent_sensible_recovery_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('mech_vent_fan_power', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('kitchen_fan_present', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('kitchen_fan_flow_rate', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('kitchen_fan_hours_in_operation', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('kitchen_fan_power', false)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('kitchen_fan_start_hour', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('bathroom_fans_present', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('bathroom_fans_flow_rate', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('bathroom_fans_hours_in_operation', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('bathroom_fans_power', false)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('bathroom_fans_start_hour', true)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('bathroom_fans_quantity', false)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('whole_house_fan_present', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('whole_house_fan_flow_rate', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('whole_house_fan_power', true)

    water_heater_type_choices = OpenStudio::StringVector.new
    water_heater_type_choices << 'none'
    water_heater_type_choices << HPXML::WaterHeaterTypeStorage
    water_heater_type_choices << HPXML::WaterHeaterTypeTankless
    water_heater_type_choices << HPXML::WaterHeaterTypeHeatPump
    water_heater_type_choices << HPXML::WaterHeaterTypeCombiStorage
    water_heater_type_choices << HPXML::WaterHeaterTypeCombiTankless

    water_heater_fuel_choices = OpenStudio::StringVector.new
    water_heater_fuel_choices << HPXML::FuelTypeElectricity
    water_heater_fuel_choices << HPXML::FuelTypeNaturalGas
    water_heater_fuel_choices << HPXML::FuelTypeOil
    water_heater_fuel_choices << HPXML::FuelTypePropane
    water_heater_fuel_choices << HPXML::FuelTypeWood

    water_heater_location_choices = OpenStudio::StringVector.new
    water_heater_location_choices << Constants.Auto
    water_heater_location_choices << HPXML::LocationLivingSpace
    water_heater_location_choices << HPXML::LocationBasementConditioned
    water_heater_location_choices << HPXML::LocationBasementUnconditioned
    water_heater_location_choices << HPXML::LocationGarage
    water_heater_location_choices << HPXML::LocationAtticVented
    water_heater_location_choices << HPXML::LocationAtticUnvented
    water_heater_location_choices << HPXML::LocationCrawlspaceVented
    water_heater_location_choices << HPXML::LocationCrawlspaceUnvented
    water_heater_location_choices << HPXML::LocationOtherExterior

    water_heater_efficiency_type_choices = OpenStudio::StringVector.new
    water_heater_efficiency_type_choices << 'EnergyFactor'
    water_heater_efficiency_type_choices << 'UniformEnergyFactor'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('water_heater_type', water_heater_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('water_heater_fuel_type', water_heater_fuel_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('water_heater_location', water_heater_location_choices, true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('water_heater_tank_volume', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('water_heater_heating_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('water_heater_efficiency_type', water_heater_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('water_heater_efficiency_ef', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('water_heater_efficiency_uef', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('water_heater_recovery_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('water_heater_standby_loss', false)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('water_heater_jacket_rvalue', false)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('water_heater_setpoint_temperature', true)

    dhw_distribution_system_type_choices = OpenStudio::StringVector.new
    dhw_distribution_system_type_choices << HPXML::DHWDistTypeStandard
    dhw_distribution_system_type_choices << HPXML::DHWDistTypeRecirc

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('dhw_distribution_system_type', dhw_distribution_system_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('dhw_distribution_standard_piping_length', true)

    recirculation_control_type_choices = OpenStudio::StringVector.new
    recirculation_control_type_choices << HPXML::DHWRecirControlTypeNone
    recirculation_control_type_choices << HPXML::DHWRecirControlTypeTimer
    recirculation_control_type_choices << HPXML::DHWRecirControlTypeTemperature
    recirculation_control_type_choices << HPXML::DHWRecirControlTypeSensor
    recirculation_control_type_choices << HPXML::DHWRecirControlTypeManual

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('dhw_distribution_recirc_control_type', recirculation_control_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('dhw_distribution_recirc_piping_length', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('dhw_distribution_recirc_branch_piping_length', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('dhw_distribution_recirc_pump_power', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dhw_distribution_pipe_r', true)

    dwhr_facilities_connected_choices = OpenStudio::StringVector.new
    dwhr_facilities_connected_choices << 'none'
    dwhr_facilities_connected_choices << HPXML::DWHRFacilitiesConnectedOne
    dwhr_facilities_connected_choices << HPXML::DWHRFacilitiesConnectedAll

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('dwhr_facilities_connected', dwhr_facilities_connected_choices, true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('dwhr_equal_flow', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dwhr_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('water_fixtures_shower_low_flow', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('water_fixtures_sink_low_flow', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('water_fixtures_usage_multiplier', true)

    solar_thermal_system_type_choices = OpenStudio::StringVector.new
    solar_thermal_system_type_choices << 'none'
    solar_thermal_system_type_choices << 'hot water'

    solar_thermal_collector_loop_type_choices = OpenStudio::StringVector.new
    solar_thermal_collector_loop_type_choices << HPXML::SolarThermalLoopTypeDirect
    solar_thermal_collector_loop_type_choices << HPXML::SolarThermalLoopTypeIndirect
    solar_thermal_collector_loop_type_choices << HPXML::SolarThermalLoopTypeThermosyphon

    solar_thermal_collector_type_choices = OpenStudio::StringVector.new
    solar_thermal_collector_type_choices << HPXML::SolarThermalTypeEvacuatedTube
    solar_thermal_collector_type_choices << HPXML::SolarThermalTypeSingleGlazing
    solar_thermal_collector_type_choices << HPXML::SolarThermalTypeDoubleGlazing
    solar_thermal_collector_type_choices << HPXML::SolarThermalTypeICS

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('solar_thermal_system_type', solar_thermal_system_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('solar_thermal_collector_area', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('solar_thermal_collector_loop_type', solar_thermal_collector_loop_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('solar_thermal_collector_type', solar_thermal_collector_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('solar_thermal_collector_azimuth', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('solar_thermal_collector_tilt', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('solar_thermal_collector_rated_optical_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('solar_thermal_collector_rated_thermal_losses', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('solar_thermal_storage_volume', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('solar_thermal_solar_fraction', true)

    pv_system_module_type_choices = OpenStudio::StringVector.new
    pv_system_module_type_choices << 'none'
    pv_system_module_type_choices << HPXML::PVModuleTypeStandard
    pv_system_module_type_choices << HPXML::PVModuleTypePremium
    pv_system_module_type_choices << HPXML::PVModuleTypeThinFilm

    pv_system_location_choices = OpenStudio::StringVector.new
    pv_system_location_choices << HPXML::LocationRoof
    pv_system_location_choices << HPXML::LocationGround

    pv_system_tracking_choices = OpenStudio::StringVector.new
    pv_system_tracking_choices << HPXML::PVTrackingTypeFixed
    pv_system_tracking_choices << HPXML::PVTrackingType1Axis
    pv_system_tracking_choices << HPXML::PVTrackingType1AxisBacktracked
    pv_system_tracking_choices << HPXML::PVTrackingType2Axis

    (1..Constants.MaxNumPhotovoltaics).to_a.each do |n|
      args << OpenStudio::Measure::OSArgument::makeChoiceArgument("pv_system_module_type_#{n}", pv_system_module_type_choices, true)
      args << OpenStudio::Measure::OSArgument::makeChoiceArgument("pv_system_location_#{n}", pv_system_location_choices, true)
      args << OpenStudio::Measure::OSArgument::makeChoiceArgument("pv_system_tracking_#{n}", pv_system_tracking_choices, true)
      args << OpenStudio::Measure::OSArgument::makeDoubleArgument("pv_system_array_azimuth_#{n}", true)
      args << OpenStudio::Measure::OSArgument::makeStringArgument("pv_system_array_tilt_#{n}", true)
      args << OpenStudio::Measure::OSArgument::makeDoubleArgument("pv_system_max_power_output_#{n}", true)
      args << OpenStudio::Measure::OSArgument::makeDoubleArgument("pv_system_inverter_efficiency_#{n}", true)
      args << OpenStudio::Measure::OSArgument::makeDoubleArgument("pv_system_system_losses_fraction_#{n}", true)
    end

    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_cfl_interior', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_lfl_interior', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_led_interior', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_cfl_exterior', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_lfl_exterior', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_led_exterior', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_cfl_garage', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_lfl_garage', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_fraction_led_garage', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('lighting_usage_multiplier', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('dehumidifier_present', true)

    dehumidifier_efficiency_type_choices = OpenStudio::StringVector.new
    dehumidifier_efficiency_type_choices << 'EnergyFactor'
    dehumidifier_efficiency_type_choices << 'IntegratedEnergyFactor'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('dehumidifier_efficiency_type', dehumidifier_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dehumidifier_efficiency_ef', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dehumidifier_efficiency_ief', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dehumidifier_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dehumidifier_rh_setpoint', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dehumidifier_fraction_dehumidification_load_served', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('clothes_washer_present', true)

    appliance_location_choices = OpenStudio::StringVector.new
    appliance_location_choices << Constants.Auto
    appliance_location_choices << HPXML::LocationLivingSpace
    appliance_location_choices << HPXML::LocationBasementConditioned
    appliance_location_choices << HPXML::LocationBasementUnconditioned
    appliance_location_choices << HPXML::LocationGarage
    appliance_location_choices << HPXML::LocationOther

    clothes_washer_efficiency_type_choices = OpenStudio::StringVector.new
    clothes_washer_efficiency_type_choices << 'ModifiedEnergyFactor'
    clothes_washer_efficiency_type_choices << 'IntegratedModifiedEnergyFactor'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('clothes_washer_location', appliance_location_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('clothes_washer_efficiency_type', clothes_washer_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_efficiency_mef', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_efficiency_imef', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_rated_annual_kwh', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_label_electric_rate', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_label_gas_rate', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_label_annual_gas_cost', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_label_usage', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_washer_usage_multiplier', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('clothes_dryer_present', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('clothes_dryer_location', appliance_location_choices, true)

    clothes_dryer_fuel_choices = OpenStudio::StringVector.new
    clothes_dryer_fuel_choices << HPXML::FuelTypeElectricity
    clothes_dryer_fuel_choices << HPXML::FuelTypeNaturalGas
    clothes_dryer_fuel_choices << HPXML::FuelTypeOil
    clothes_dryer_fuel_choices << HPXML::FuelTypePropane
    clothes_dryer_fuel_choices << HPXML::FuelTypeWood

    clothes_dryer_control_type_choices = OpenStudio::StringVector.new
    clothes_dryer_control_type_choices << HPXML::ClothesDryerControlTypeTimer
    clothes_dryer_control_type_choices << HPXML::ClothesDryerControlTypeMoisture

    clothes_dryer_efficiency_type_choices = OpenStudio::StringVector.new
    clothes_dryer_efficiency_type_choices << 'EnergyFactor'
    clothes_dryer_efficiency_type_choices << 'CombinedEnergyFactor'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('clothes_dryer_fuel_type', clothes_dryer_fuel_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('clothes_dryer_efficiency_type', clothes_dryer_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_dryer_efficiency_ef', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_dryer_efficiency_cef', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('clothes_dryer_control_type', clothes_dryer_control_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('clothes_dryer_usage_multiplier', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('dishwasher_present', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('dishwasher_location', appliance_location_choices, true)

    dishwasher_efficiency_type_choices = OpenStudio::StringVector.new
    dishwasher_efficiency_type_choices << 'RatedAnnualkWh'
    dishwasher_efficiency_type_choices << 'EnergyFactor'

    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('dishwasher_efficiency_type', dishwasher_efficiency_type_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_efficiency_kwh', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_efficiency_ef', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_label_electric_rate', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_label_gas_rate', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_label_annual_gas_cost', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_label_usage', true)
    args << OpenStudio::Measure::OSArgument::makeIntegerArgument('dishwasher_place_setting_capacity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('dishwasher_usage_multiplier', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('refrigerator_present', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('refrigerator_location', appliance_location_choices, true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('refrigerator_rated_annual_kwh', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('refrigerator_usage_multiplier', true)

    cooking_range_oven_fuel_choices = OpenStudio::StringVector.new
    cooking_range_oven_fuel_choices << HPXML::FuelTypeElectricity
    cooking_range_oven_fuel_choices << HPXML::FuelTypeNaturalGas
    cooking_range_oven_fuel_choices << HPXML::FuelTypeOil
    cooking_range_oven_fuel_choices << HPXML::FuelTypePropane
    cooking_range_oven_fuel_choices << HPXML::FuelTypeWood

    args << OpenStudio::Measure::OSArgument::makeBoolArgument('cooking_range_oven_present', true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('cooking_range_oven_location', appliance_location_choices, true)
    args << OpenStudio::Measure::OSArgument::makeChoiceArgument('cooking_range_oven_fuel_type', cooking_range_oven_fuel_choices, true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('cooking_range_oven_is_induction', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('cooking_range_oven_is_convection', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('cooking_range_oven_usage_multiplier', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ceiling_fan_efficiency', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('ceiling_fan_quantity', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('ceiling_fan_cooling_setpoint_temp_offset', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('plug_loads_television_annual_kwh', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('plug_loads_other_annual_kwh', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('plug_loads_other_frac_sensible', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('plug_loads_other_frac_latent', true)
    args << OpenStudio::Measure::OSArgument::makeBoolArgument('plug_loads_schedule_values', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('plug_loads_weekday_fractions', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('plug_loads_weekend_fractions', true)
    args << OpenStudio::Measure::OSArgument::makeStringArgument('plug_loads_monthly_multipliers', true)
    args << OpenStudio::Measure::OSArgument::makeDoubleArgument('plug_loads_usage_multiplier', true)

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    args = { simulation_control_timestep: runner.getIntegerArgumentValue('simulation_control_timestep', user_arguments),
             simulation_control_begin_month: runner.getIntegerArgumentValue('simulation_control_begin_month', user_arguments),
             simulation_control_begin_day_of_month: runner.getIntegerArgumentValue('simulation_control_begin_day_of_month', user_arguments),
             simulation_control_end_month: runner.getIntegerArgumentValue('simulation_control_end_month', user_arguments),
             simulation_control_end_day_of_month: runner.getIntegerArgumentValue('simulation_control_end_day_of_month', user_arguments),
             weather_station_epw_filepath: runner.getStringArgumentValue('weather_station_epw_filepath', user_arguments),
             site_type: runner.getStringArgumentValue('site_type', user_arguments),
             geometry_unit_type: runner.getStringArgumentValue('geometry_unit_type', user_arguments),
             geometry_num_units: runner.getOptionalIntegerArgumentValue('geometry_num_units', user_arguments),
             geometry_cfa: runner.getDoubleArgumentValue('geometry_cfa', user_arguments),
             geometry_num_floors_above_grade: runner.getIntegerArgumentValue('geometry_num_floors_above_grade', user_arguments),
             geometry_wall_height: runner.getDoubleArgumentValue('geometry_wall_height', user_arguments),
             geometry_orientation: runner.getDoubleArgumentValue('geometry_orientation', user_arguments),
             geometry_aspect_ratio: runner.getDoubleArgumentValue('geometry_aspect_ratio', user_arguments),
             geometry_level: runner.getStringArgumentValue('geometry_level', user_arguments),
             geometry_horizontal_location: runner.getStringArgumentValue('geometry_horizontal_location', user_arguments),
             geometry_corridor_position: runner.getStringArgumentValue('geometry_corridor_position', user_arguments),
             geometry_corridor_width: runner.getDoubleArgumentValue('geometry_corridor_width', user_arguments),
             geometry_inset_width: runner.getDoubleArgumentValue('geometry_inset_width', user_arguments),
             geometry_inset_depth: runner.getDoubleArgumentValue('geometry_inset_depth', user_arguments),
             geometry_inset_position: runner.getStringArgumentValue('geometry_inset_position', user_arguments),
             geometry_balcony_depth: runner.getDoubleArgumentValue('geometry_balcony_depth', user_arguments),
             geometry_garage_width: runner.getDoubleArgumentValue('geometry_garage_width', user_arguments),
             geometry_garage_depth: runner.getDoubleArgumentValue('geometry_garage_depth', user_arguments),
             geometry_garage_protrusion: runner.getDoubleArgumentValue('geometry_garage_protrusion', user_arguments),
             geometry_garage_position: runner.getStringArgumentValue('geometry_garage_position', user_arguments),
             geometry_foundation_type: runner.getStringArgumentValue('geometry_foundation_type', user_arguments),
             geometry_foundation_height: runner.getDoubleArgumentValue('geometry_foundation_height', user_arguments),
             geometry_foundation_height_above_grade: runner.getDoubleArgumentValue('geometry_foundation_height_above_grade', user_arguments),
             geometry_roof_type: runner.getStringArgumentValue('geometry_roof_type', user_arguments),
             geometry_roof_pitch: runner.getStringArgumentValue('geometry_roof_pitch', user_arguments),
             geometry_roof_structure: runner.getStringArgumentValue('geometry_roof_structure', user_arguments),
             geometry_attic_type: runner.getStringArgumentValue('geometry_attic_type', user_arguments),
             geometry_eaves_depth: runner.getDoubleArgumentValue('geometry_eaves_depth', user_arguments),
             geometry_num_bedrooms: runner.getIntegerArgumentValue('geometry_num_bedrooms', user_arguments),
             geometry_num_bathrooms: runner.getStringArgumentValue('geometry_num_bathrooms', user_arguments),
             geometry_num_occupants: runner.getStringArgumentValue('geometry_num_occupants', user_arguments),
             floor_assembly_r: runner.getDoubleArgumentValue('floor_assembly_r', user_arguments),
             foundation_wall_insulation_r: runner.getDoubleArgumentValue('foundation_wall_insulation_r', user_arguments),
             foundation_wall_insulation_distance_to_top: runner.getDoubleArgumentValue('foundation_wall_insulation_distance_to_top', user_arguments),
             foundation_wall_insulation_distance_to_bottom: runner.getDoubleArgumentValue('foundation_wall_insulation_distance_to_bottom', user_arguments),
             foundation_wall_assembly_r: runner.getOptionalDoubleArgumentValue('foundation_wall_assembly_r', user_arguments),
             slab_perimeter_insulation_r: runner.getDoubleArgumentValue('slab_perimeter_insulation_r', user_arguments),
             slab_perimeter_depth: runner.getDoubleArgumentValue('slab_perimeter_depth', user_arguments),
             slab_under_insulation_r: runner.getDoubleArgumentValue('slab_under_insulation_r', user_arguments),
             slab_under_width: runner.getDoubleArgumentValue('slab_under_width', user_arguments),
             slab_carpet_fraction: runner.getDoubleArgumentValue('slab_carpet_fraction', user_arguments),
             slab_carpet_r: runner.getDoubleArgumentValue('slab_carpet_r', user_arguments),
             ceiling_assembly_r: runner.getDoubleArgumentValue('ceiling_assembly_r', user_arguments),
             roof_assembly_r: runner.getDoubleArgumentValue('roof_assembly_r', user_arguments),
             roof_solar_absorptance: runner.getDoubleArgumentValue('roof_solar_absorptance', user_arguments),
             roof_emittance: runner.getDoubleArgumentValue('roof_emittance', user_arguments),
             roof_radiant_barrier: runner.getBoolArgumentValue('roof_radiant_barrier', user_arguments),
             neighbor_front_distance: runner.getDoubleArgumentValue('neighbor_front_distance', user_arguments),
             neighbor_back_distance: runner.getDoubleArgumentValue('neighbor_back_distance', user_arguments),
             neighbor_left_distance: runner.getDoubleArgumentValue('neighbor_left_distance', user_arguments),
             neighbor_right_distance: runner.getDoubleArgumentValue('neighbor_right_distance', user_arguments),
             neighbor_front_height: runner.getStringArgumentValue('neighbor_front_height', user_arguments),
             neighbor_back_height: runner.getStringArgumentValue('neighbor_back_height', user_arguments),
             neighbor_left_height: runner.getStringArgumentValue('neighbor_left_height', user_arguments),
             neighbor_right_height: runner.getStringArgumentValue('neighbor_right_height', user_arguments),
             wall_type: runner.getStringArgumentValue('wall_type', user_arguments),
             wall_assembly_r: runner.getDoubleArgumentValue('wall_assembly_r', user_arguments),
             wall_solar_absorptance: runner.getDoubleArgumentValue('wall_solar_absorptance', user_arguments),
             wall_emittance: runner.getDoubleArgumentValue('wall_emittance', user_arguments),
             window_front_wwr: runner.getDoubleArgumentValue('window_front_wwr', user_arguments),
             window_back_wwr: runner.getDoubleArgumentValue('window_back_wwr', user_arguments),
             window_left_wwr: runner.getDoubleArgumentValue('window_left_wwr', user_arguments),
             window_right_wwr: runner.getDoubleArgumentValue('window_right_wwr', user_arguments),
             window_area_front: runner.getDoubleArgumentValue('window_area_front', user_arguments),
             window_area_back: runner.getDoubleArgumentValue('window_area_back', user_arguments),
             window_area_left: runner.getDoubleArgumentValue('window_area_left', user_arguments),
             window_area_right: runner.getDoubleArgumentValue('window_area_right', user_arguments),
             window_aspect_ratio: runner.getDoubleArgumentValue('window_aspect_ratio', user_arguments),
             window_fraction_operable: runner.getDoubleArgumentValue('window_fraction_operable', user_arguments),
             window_ufactor: runner.getDoubleArgumentValue('window_ufactor', user_arguments),
             window_shgc: runner.getDoubleArgumentValue('window_shgc', user_arguments),
             window_interior_shading_winter: runner.getDoubleArgumentValue('window_interior_shading_winter', user_arguments),
             window_interior_shading_summer: runner.getDoubleArgumentValue('window_interior_shading_summer', user_arguments),
             overhangs_front_depth: runner.getDoubleArgumentValue('overhangs_front_depth', user_arguments),
             overhangs_front_distance_to_top_of_window: runner.getDoubleArgumentValue('overhangs_front_distance_to_top_of_window', user_arguments),
             overhangs_back_depth: runner.getDoubleArgumentValue('overhangs_back_depth', user_arguments),
             overhangs_back_distance_to_top_of_window: runner.getDoubleArgumentValue('overhangs_back_distance_to_top_of_window', user_arguments),
             overhangs_left_depth: runner.getDoubleArgumentValue('overhangs_left_depth', user_arguments),
             overhangs_left_distance_to_top_of_window: runner.getDoubleArgumentValue('overhangs_left_distance_to_top_of_window', user_arguments),
             overhangs_right_depth: runner.getDoubleArgumentValue('overhangs_right_depth', user_arguments),
             overhangs_right_distance_to_top_of_window: runner.getDoubleArgumentValue('overhangs_right_distance_to_top_of_window', user_arguments),
             skylight_area_front: runner.getDoubleArgumentValue('skylight_area_front', user_arguments),
             skylight_area_back: runner.getDoubleArgumentValue('skylight_area_back', user_arguments),
             skylight_area_left: runner.getDoubleArgumentValue('skylight_area_left', user_arguments),
             skylight_area_right: runner.getDoubleArgumentValue('skylight_area_right', user_arguments),
             skylight_ufactor: runner.getDoubleArgumentValue('skylight_ufactor', user_arguments),
             skylight_shgc: runner.getDoubleArgumentValue('skylight_shgc', user_arguments),
             door_area: runner.getDoubleArgumentValue('door_area', user_arguments),
             door_rvalue: runner.getDoubleArgumentValue('door_rvalue', user_arguments),
             air_leakage_units: runner.getStringArgumentValue('air_leakage_units', user_arguments),
             air_leakage_value: runner.getDoubleArgumentValue('air_leakage_value', user_arguments),
             air_leakage_shelter_coefficient: runner.getStringArgumentValue('air_leakage_shelter_coefficient', user_arguments),
             heating_system_type: runner.getStringArgumentValue('heating_system_type', user_arguments),
             heating_system_fuel: runner.getStringArgumentValue('heating_system_fuel', user_arguments),
             heating_system_heating_efficiency_afue: runner.getDoubleArgumentValue('heating_system_heating_efficiency_afue', user_arguments),
             heating_system_heating_efficiency_percent: runner.getDoubleArgumentValue('heating_system_heating_efficiency_percent', user_arguments),
             heating_system_heating_capacity: runner.getStringArgumentValue('heating_system_heating_capacity', user_arguments),
             heating_system_fraction_heat_load_served: runner.getDoubleArgumentValue('heating_system_fraction_heat_load_served', user_arguments),
             heating_system_electric_auxiliary_energy: runner.getOptionalDoubleArgumentValue('heating_system_electric_auxiliary_energy', user_arguments),
             cooling_system_type: runner.getStringArgumentValue('cooling_system_type', user_arguments),
             cooling_system_cooling_efficiency_seer: runner.getDoubleArgumentValue('cooling_system_cooling_efficiency_seer', user_arguments),
             cooling_system_cooling_efficiency_eer: runner.getDoubleArgumentValue('cooling_system_cooling_efficiency_eer', user_arguments),
             cooling_system_cooling_compressor_type: runner.getOptionalStringArgumentValue('cooling_system_cooling_compressor_type', user_arguments),
             cooling_system_cooling_sensible_heat_fraction: runner.getOptionalDoubleArgumentValue('cooling_system_cooling_sensible_heat_fraction', user_arguments),
             cooling_system_cooling_capacity: runner.getStringArgumentValue('cooling_system_cooling_capacity', user_arguments),
             cooling_system_fraction_cool_load_served: runner.getDoubleArgumentValue('cooling_system_fraction_cool_load_served', user_arguments),
             cooling_system_evap_cooler_is_ducted: runner.getBoolArgumentValue('cooling_system_evap_cooler_is_ducted', user_arguments),
             heat_pump_type: runner.getStringArgumentValue('heat_pump_type', user_arguments),
             heat_pump_heating_efficiency_hspf: runner.getDoubleArgumentValue('heat_pump_heating_efficiency_hspf', user_arguments),
             heat_pump_heating_efficiency_cop: runner.getDoubleArgumentValue('heat_pump_heating_efficiency_cop', user_arguments),
             heat_pump_cooling_efficiency_seer: runner.getDoubleArgumentValue('heat_pump_cooling_efficiency_seer', user_arguments),
             heat_pump_cooling_efficiency_eer: runner.getDoubleArgumentValue('heat_pump_cooling_efficiency_eer', user_arguments),
             heat_pump_cooling_compressor_type: runner.getOptionalStringArgumentValue('heat_pump_cooling_compressor_type', user_arguments),
             heat_pump_cooling_sensible_heat_fraction: runner.getOptionalDoubleArgumentValue('heat_pump_cooling_sensible_heat_fraction', user_arguments),
             heat_pump_heating_capacity: runner.getStringArgumentValue('heat_pump_heating_capacity', user_arguments),
             heat_pump_heating_capacity_17F: runner.getStringArgumentValue('heat_pump_heating_capacity_17F', user_arguments),
             heat_pump_cooling_capacity: runner.getStringArgumentValue('heat_pump_cooling_capacity', user_arguments),
             heat_pump_fraction_heat_load_served: runner.getDoubleArgumentValue('heat_pump_fraction_heat_load_served', user_arguments),
             heat_pump_fraction_cool_load_served: runner.getDoubleArgumentValue('heat_pump_fraction_cool_load_served', user_arguments),
             heat_pump_backup_fuel: runner.getStringArgumentValue('heat_pump_backup_fuel', user_arguments),
             heat_pump_backup_heating_efficiency: runner.getDoubleArgumentValue('heat_pump_backup_heating_efficiency', user_arguments),
             heat_pump_backup_heating_capacity: runner.getStringArgumentValue('heat_pump_backup_heating_capacity', user_arguments),
             heat_pump_backup_heating_switchover_temp: runner.getOptionalDoubleArgumentValue('heat_pump_backup_heating_switchover_temp', user_arguments),
             heat_pump_mini_split_is_ducted: runner.getBoolArgumentValue('heat_pump_mini_split_is_ducted', user_arguments),
             setpoint_heating_temp: runner.getDoubleArgumentValue('setpoint_heating_temp', user_arguments),
             setpoint_heating_setback_temp: runner.getDoubleArgumentValue('setpoint_heating_setback_temp', user_arguments),
             setpoint_heating_setback_hours_per_week: runner.getDoubleArgumentValue('setpoint_heating_setback_hours_per_week', user_arguments),
             setpoint_heating_setback_start_hour: runner.getDoubleArgumentValue('setpoint_heating_setback_start_hour', user_arguments),
             setpoint_cooling_temp: runner.getDoubleArgumentValue('setpoint_cooling_temp', user_arguments),
             setpoint_cooling_setup_temp: runner.getDoubleArgumentValue('setpoint_cooling_setup_temp', user_arguments),
             setpoint_cooling_setup_hours_per_week: runner.getDoubleArgumentValue('setpoint_cooling_setup_hours_per_week', user_arguments),
             setpoint_cooling_setup_start_hour: runner.getDoubleArgumentValue('setpoint_cooling_setup_start_hour', user_arguments),
             ducts_supply_leakage_units: runner.getStringArgumentValue('ducts_supply_leakage_units', user_arguments),
             ducts_return_leakage_units: runner.getStringArgumentValue('ducts_return_leakage_units', user_arguments),
             ducts_supply_leakage_value: runner.getDoubleArgumentValue('ducts_supply_leakage_value', user_arguments),
             ducts_return_leakage_value: runner.getDoubleArgumentValue('ducts_return_leakage_value', user_arguments),
             ducts_supply_insulation_r: runner.getDoubleArgumentValue('ducts_supply_insulation_r', user_arguments),
             ducts_return_insulation_r: runner.getDoubleArgumentValue('ducts_return_insulation_r', user_arguments),
             ducts_supply_location: runner.getStringArgumentValue('ducts_supply_location', user_arguments),
             ducts_return_location: runner.getStringArgumentValue('ducts_return_location', user_arguments),
             ducts_supply_surface_area: runner.getStringArgumentValue('ducts_supply_surface_area', user_arguments),
             ducts_return_surface_area: runner.getStringArgumentValue('ducts_return_surface_area', user_arguments),
             mech_vent_fan_type: runner.getStringArgumentValue('mech_vent_fan_type', user_arguments),
             mech_vent_flow_rate: runner.getDoubleArgumentValue('mech_vent_flow_rate', user_arguments),
             mech_vent_hours_in_operation: runner.getDoubleArgumentValue('mech_vent_hours_in_operation', user_arguments),
             mech_vent_total_recovery_efficiency_type: runner.getStringArgumentValue('mech_vent_total_recovery_efficiency_type', user_arguments),
             mech_vent_total_recovery_efficiency: runner.getDoubleArgumentValue('mech_vent_total_recovery_efficiency', user_arguments),
             mech_vent_sensible_recovery_efficiency_type: runner.getStringArgumentValue('mech_vent_sensible_recovery_efficiency_type', user_arguments),
             mech_vent_sensible_recovery_efficiency: runner.getDoubleArgumentValue('mech_vent_sensible_recovery_efficiency', user_arguments),
             mech_vent_fan_power: runner.getDoubleArgumentValue('mech_vent_fan_power', user_arguments),
             kitchen_fan_present: runner.getBoolArgumentValue('kitchen_fan_present', user_arguments),
             kitchen_fan_flow_rate: runner.getOptionalDoubleArgumentValue('kitchen_fan_flow_rate', user_arguments),
             kitchen_fan_hours_in_operation: runner.getOptionalDoubleArgumentValue('kitchen_fan_hours_in_operation', user_arguments),
             kitchen_fan_power: runner.getOptionalDoubleArgumentValue('kitchen_fan_power', user_arguments),
             kitchen_fan_start_hour: runner.getIntegerArgumentValue('kitchen_fan_start_hour', user_arguments),
             bathroom_fans_present: runner.getBoolArgumentValue('bathroom_fans_present', user_arguments),
             bathroom_fans_flow_rate: runner.getOptionalDoubleArgumentValue('bathroom_fans_flow_rate', user_arguments),
             bathroom_fans_hours_in_operation: runner.getOptionalDoubleArgumentValue('bathroom_fans_hours_in_operation', user_arguments),
             bathroom_fans_power: runner.getOptionalDoubleArgumentValue('bathroom_fans_power', user_arguments),
             bathroom_fans_start_hour: runner.getIntegerArgumentValue('bathroom_fans_start_hour', user_arguments),
             bathroom_fans_quantity: runner.getOptionalIntegerArgumentValue('bathroom_fans_quantity', user_arguments),
             whole_house_fan_present: runner.getBoolArgumentValue('whole_house_fan_present', user_arguments),
             whole_house_fan_flow_rate: runner.getDoubleArgumentValue('whole_house_fan_flow_rate', user_arguments),
             whole_house_fan_power: runner.getDoubleArgumentValue('whole_house_fan_power', user_arguments),
             water_heater_type: runner.getStringArgumentValue('water_heater_type', user_arguments),
             water_heater_fuel_type: runner.getStringArgumentValue('water_heater_fuel_type', user_arguments),
             water_heater_location: runner.getStringArgumentValue('water_heater_location', user_arguments),
             water_heater_tank_volume: runner.getStringArgumentValue('water_heater_tank_volume', user_arguments),
             water_heater_heating_capacity: runner.getStringArgumentValue('water_heater_heating_capacity', user_arguments),
             water_heater_efficiency_type: runner.getStringArgumentValue('water_heater_efficiency_type', user_arguments),
             water_heater_efficiency_ef: runner.getDoubleArgumentValue('water_heater_efficiency_ef', user_arguments),
             water_heater_efficiency_uef: runner.getDoubleArgumentValue('water_heater_efficiency_uef', user_arguments),
             water_heater_recovery_efficiency: runner.getStringArgumentValue('water_heater_recovery_efficiency', user_arguments),
             water_heater_standby_loss: runner.getOptionalDoubleArgumentValue('water_heater_standby_loss', user_arguments),
             water_heater_jacket_rvalue: runner.getOptionalDoubleArgumentValue('water_heater_jacket_rvalue', user_arguments),
             water_heater_setpoint_temperature: runner.getStringArgumentValue('water_heater_setpoint_temperature', user_arguments),
             dhw_distribution_system_type: runner.getStringArgumentValue('dhw_distribution_system_type', user_arguments),
             dhw_distribution_standard_piping_length: runner.getStringArgumentValue('dhw_distribution_standard_piping_length', user_arguments),
             dhw_distribution_recirc_control_type: runner.getStringArgumentValue('dhw_distribution_recirc_control_type', user_arguments),
             dhw_distribution_recirc_piping_length: runner.getStringArgumentValue('dhw_distribution_recirc_piping_length', user_arguments),
             dhw_distribution_recirc_branch_piping_length: runner.getStringArgumentValue('dhw_distribution_recirc_branch_piping_length', user_arguments),
             dhw_distribution_recirc_pump_power: runner.getStringArgumentValue('dhw_distribution_recirc_pump_power', user_arguments),
             dhw_distribution_pipe_r: runner.getDoubleArgumentValue('dhw_distribution_pipe_r', user_arguments),
             dwhr_facilities_connected: runner.getStringArgumentValue('dwhr_facilities_connected', user_arguments),
             dwhr_equal_flow: runner.getBoolArgumentValue('dwhr_equal_flow', user_arguments),
             dwhr_efficiency: runner.getDoubleArgumentValue('dwhr_efficiency', user_arguments),
             water_fixtures_shower_low_flow: runner.getBoolArgumentValue('water_fixtures_shower_low_flow', user_arguments),
             water_fixtures_sink_low_flow: runner.getBoolArgumentValue('water_fixtures_sink_low_flow', user_arguments),
             water_fixtures_usage_multiplier: runner.getDoubleArgumentValue('water_fixtures_usage_multiplier', user_arguments),
             solar_thermal_system_type: runner.getStringArgumentValue('solar_thermal_system_type', user_arguments),
             solar_thermal_collector_area: runner.getDoubleArgumentValue('solar_thermal_collector_area', user_arguments),
             solar_thermal_collector_loop_type: runner.getStringArgumentValue('solar_thermal_collector_loop_type', user_arguments),
             solar_thermal_collector_type: runner.getStringArgumentValue('solar_thermal_collector_type', user_arguments),
             solar_thermal_collector_azimuth: runner.getDoubleArgumentValue('solar_thermal_collector_azimuth', user_arguments),
             solar_thermal_collector_tilt: runner.getStringArgumentValue('solar_thermal_collector_tilt', user_arguments),
             solar_thermal_collector_rated_optical_efficiency: runner.getDoubleArgumentValue('solar_thermal_collector_rated_optical_efficiency', user_arguments),
             solar_thermal_collector_rated_thermal_losses: runner.getDoubleArgumentValue('solar_thermal_collector_rated_thermal_losses', user_arguments),
             solar_thermal_storage_volume: runner.getStringArgumentValue('solar_thermal_storage_volume', user_arguments),
             solar_thermal_solar_fraction: runner.getDoubleArgumentValue('solar_thermal_solar_fraction', user_arguments),
             pv_system_module_type_1: runner.getStringArgumentValue('pv_system_module_type_1', user_arguments),
             pv_system_location_1: runner.getStringArgumentValue('pv_system_location_1', user_arguments),
             pv_system_tracking_1: runner.getStringArgumentValue('pv_system_tracking_1', user_arguments),
             pv_system_array_azimuth_1: runner.getDoubleArgumentValue('pv_system_array_azimuth_1', user_arguments),
             pv_system_array_tilt_1: runner.getStringArgumentValue('pv_system_array_tilt_1', user_arguments),
             pv_system_max_power_output_1: runner.getDoubleArgumentValue('pv_system_max_power_output_1', user_arguments),
             pv_system_inverter_efficiency_1: runner.getDoubleArgumentValue('pv_system_inverter_efficiency_1', user_arguments),
             pv_system_system_losses_fraction_1: runner.getDoubleArgumentValue('pv_system_system_losses_fraction_1', user_arguments),
             pv_system_module_type_2: runner.getStringArgumentValue('pv_system_module_type_2', user_arguments),
             pv_system_location_2: runner.getStringArgumentValue('pv_system_location_2', user_arguments),
             pv_system_tracking_2: runner.getStringArgumentValue('pv_system_tracking_2', user_arguments),
             pv_system_array_azimuth_2: runner.getDoubleArgumentValue('pv_system_array_azimuth_2', user_arguments),
             pv_system_array_tilt_2: runner.getStringArgumentValue('pv_system_array_tilt_2', user_arguments),
             pv_system_max_power_output_2: runner.getDoubleArgumentValue('pv_system_max_power_output_2', user_arguments),
             pv_system_inverter_efficiency_2: runner.getDoubleArgumentValue('pv_system_inverter_efficiency_2', user_arguments),
             pv_system_system_losses_fraction_2: runner.getDoubleArgumentValue('pv_system_system_losses_fraction_2', user_arguments),
             lighting_fraction_cfl_interior: runner.getDoubleArgumentValue('lighting_fraction_cfl_interior', user_arguments),
             lighting_fraction_lfl_interior: runner.getDoubleArgumentValue('lighting_fraction_lfl_interior', user_arguments),
             lighting_fraction_led_interior: runner.getDoubleArgumentValue('lighting_fraction_led_interior', user_arguments),
             lighting_fraction_cfl_exterior: runner.getDoubleArgumentValue('lighting_fraction_cfl_exterior', user_arguments),
             lighting_fraction_lfl_exterior: runner.getDoubleArgumentValue('lighting_fraction_lfl_exterior', user_arguments),
             lighting_fraction_led_exterior: runner.getDoubleArgumentValue('lighting_fraction_led_exterior', user_arguments),
             lighting_fraction_cfl_garage: runner.getDoubleArgumentValue('lighting_fraction_cfl_garage', user_arguments),
             lighting_fraction_lfl_garage: runner.getDoubleArgumentValue('lighting_fraction_lfl_garage', user_arguments),
             lighting_fraction_led_garage: runner.getDoubleArgumentValue('lighting_fraction_led_garage', user_arguments),
             lighting_usage_multiplier: runner.getDoubleArgumentValue('lighting_usage_multiplier', user_arguments),
             dehumidifier_present: runner.getBoolArgumentValue('dehumidifier_present', user_arguments),
             dehumidifier_efficiency_type: runner.getStringArgumentValue('dehumidifier_efficiency_type', user_arguments),
             dehumidifier_efficiency_ef: runner.getDoubleArgumentValue('dehumidifier_efficiency_ef', user_arguments),
             dehumidifier_efficiency_ief: runner.getDoubleArgumentValue('dehumidifier_efficiency_ief', user_arguments),
             dehumidifier_capacity: runner.getDoubleArgumentValue('dehumidifier_capacity', user_arguments),
             dehumidifier_rh_setpoint: runner.getDoubleArgumentValue('dehumidifier_rh_setpoint', user_arguments),
             dehumidifier_fraction_dehumidification_load_served: runner.getDoubleArgumentValue('dehumidifier_fraction_dehumidification_load_served', user_arguments),
             clothes_washer_present: runner.getBoolArgumentValue('clothes_washer_present', user_arguments),
             clothes_washer_location: runner.getStringArgumentValue('clothes_washer_location', user_arguments),
             clothes_washer_efficiency_type: runner.getStringArgumentValue('clothes_washer_efficiency_type', user_arguments),
             clothes_washer_efficiency_mef: runner.getDoubleArgumentValue('clothes_washer_efficiency_mef', user_arguments),
             clothes_washer_efficiency_imef: runner.getDoubleArgumentValue('clothes_washer_efficiency_imef', user_arguments),
             clothes_washer_rated_annual_kwh: runner.getDoubleArgumentValue('clothes_washer_rated_annual_kwh', user_arguments),
             clothes_washer_label_electric_rate: runner.getDoubleArgumentValue('clothes_washer_label_electric_rate', user_arguments),
             clothes_washer_label_gas_rate: runner.getDoubleArgumentValue('clothes_washer_label_gas_rate', user_arguments),
             clothes_washer_label_annual_gas_cost: runner.getDoubleArgumentValue('clothes_washer_label_annual_gas_cost', user_arguments),
             clothes_washer_label_usage: runner.getDoubleArgumentValue('clothes_washer_label_usage', user_arguments),
             clothes_washer_capacity: runner.getDoubleArgumentValue('clothes_washer_capacity', user_arguments),
             clothes_washer_usage_multiplier: runner.getDoubleArgumentValue('clothes_washer_usage_multiplier', user_arguments),
             clothes_dryer_present: runner.getBoolArgumentValue('clothes_dryer_present', user_arguments),
             clothes_dryer_location: runner.getStringArgumentValue('clothes_dryer_location', user_arguments),
             clothes_dryer_fuel_type: runner.getStringArgumentValue('clothes_dryer_fuel_type', user_arguments),
             clothes_dryer_efficiency_type: runner.getStringArgumentValue('clothes_dryer_efficiency_type', user_arguments),
             clothes_dryer_efficiency_ef: runner.getDoubleArgumentValue('clothes_dryer_efficiency_ef', user_arguments),
             clothes_dryer_efficiency_cef: runner.getDoubleArgumentValue('clothes_dryer_efficiency_cef', user_arguments),
             clothes_dryer_control_type: runner.getStringArgumentValue('clothes_dryer_control_type', user_arguments),
             clothes_dryer_usage_multiplier: runner.getDoubleArgumentValue('clothes_dryer_usage_multiplier', user_arguments),
             dishwasher_present: runner.getBoolArgumentValue('dishwasher_present', user_arguments),
             dishwasher_location: runner.getStringArgumentValue('dishwasher_location', user_arguments),
             dishwasher_efficiency_type: runner.getStringArgumentValue('dishwasher_efficiency_type', user_arguments),
             dishwasher_efficiency_kwh: runner.getDoubleArgumentValue('dishwasher_efficiency_kwh', user_arguments),
             dishwasher_efficiency_ef: runner.getDoubleArgumentValue('dishwasher_efficiency_ef', user_arguments),
             dishwasher_label_electric_rate: runner.getDoubleArgumentValue('dishwasher_label_electric_rate', user_arguments),
             dishwasher_label_gas_rate: runner.getDoubleArgumentValue('dishwasher_label_gas_rate', user_arguments),
             dishwasher_label_annual_gas_cost: runner.getDoubleArgumentValue('dishwasher_label_annual_gas_cost', user_arguments),
             dishwasher_label_usage: runner.getDoubleArgumentValue('dishwasher_label_usage', user_arguments),
             dishwasher_place_setting_capacity: runner.getIntegerArgumentValue('dishwasher_place_setting_capacity', user_arguments),
             dishwasher_usage_multiplier: runner.getDoubleArgumentValue('dishwasher_usage_multiplier', user_arguments),
             refrigerator_present: runner.getBoolArgumentValue('refrigerator_present', user_arguments),
             refrigerator_location: runner.getStringArgumentValue('refrigerator_location', user_arguments),
             refrigerator_rated_annual_kwh: runner.getDoubleArgumentValue('refrigerator_rated_annual_kwh', user_arguments),
             refrigerator_usage_multiplier: runner.getDoubleArgumentValue('refrigerator_usage_multiplier', user_arguments),
             cooking_range_oven_present: runner.getBoolArgumentValue('cooking_range_oven_present', user_arguments),
             cooking_range_oven_location: runner.getStringArgumentValue('cooking_range_oven_location', user_arguments),
             cooking_range_oven_fuel_type: runner.getStringArgumentValue('cooking_range_oven_fuel_type', user_arguments),
             cooking_range_oven_is_induction: runner.getStringArgumentValue('cooking_range_oven_is_induction', user_arguments),
             cooking_range_oven_is_convection: runner.getStringArgumentValue('cooking_range_oven_is_convection', user_arguments),
             cooking_range_oven_usage_multiplier: runner.getDoubleArgumentValue('cooking_range_oven_usage_multiplier', user_arguments),
             ceiling_fan_efficiency: runner.getDoubleArgumentValue('ceiling_fan_efficiency', user_arguments),
             ceiling_fan_quantity: runner.getStringArgumentValue('ceiling_fan_quantity', user_arguments),
             ceiling_fan_cooling_setpoint_temp_offset: runner.getDoubleArgumentValue('ceiling_fan_cooling_setpoint_temp_offset', user_arguments),
             plug_loads_television_annual_kwh: runner.getStringArgumentValue('plug_loads_television_annual_kwh', user_arguments),
             plug_loads_other_annual_kwh: runner.getStringArgumentValue('plug_loads_other_annual_kwh', user_arguments),
             plug_loads_other_frac_sensible: runner.getDoubleArgumentValue('plug_loads_other_frac_sensible', user_arguments),
             plug_loads_other_frac_latent: runner.getDoubleArgumentValue('plug_loads_other_frac_latent', user_arguments),
             plug_loads_schedule_values: runner.getBoolArgumentValue('plug_loads_schedule_values', user_arguments),
             plug_loads_weekday_fractions: runner.getStringArgumentValue('plug_loads_weekday_fractions', user_arguments),
             plug_loads_weekend_fractions: runner.getStringArgumentValue('plug_loads_weekend_fractions', user_arguments),
             plug_loads_monthly_multipliers: runner.getStringArgumentValue('plug_loads_monthly_multipliers', user_arguments),
             plug_loads_usage_multiplier: runner.getDoubleArgumentValue('plug_loads_usage_multiplier', user_arguments) }

    # Get file/dir paths
    resources_dir = File.absolute_path(File.join(File.dirname(__FILE__), 'resources'))
    meta_measure_file = File.join(resources_dir, 'meta_measure.rb')
    require File.join(File.dirname(meta_measure_file), File.basename(meta_measure_file, File.extname(meta_measure_file)))
    workflow_json = File.join(resources_dir, 'measure-info.json')

    # Apply HPXML measures
    measures_dir = File.absolute_path(File.join(File.dirname(__FILE__), '../../resources/hpxml-measures'))

    # Check file/dir paths exist
    check_dir_exists(measures_dir, runner)

    # Optionals: get or remove
    args.keys.each do |arg|
      begin
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
      unit_name = "unit #{num_unit}.osw"

      # BuildResidentialHPXML
      measure_subdir = 'BuildResidentialHPXML'
      full_measure_path = File.join(measures_dir, measure_subdir, 'measure.rb')
      check_file_exists(full_measure_path, runner)

      # Fill the measure args hash with default values
      measure_args = args

      measures = {}
      measures[measure_subdir] = []
      measure_args[:hpxml_path] = File.expand_path('../in.xml')
      measure_args[:weather_dir] = File.expand_path('../../../../weather')
      measure_args[:schedules_output_path] = '../schedules.csv'
      measure_args = Hash[measure_args.collect{ |k, v| [k.to_s, v] }]
      measures[measure_subdir] << measure_args

      # HPXMLtoOpenStudio
      measure_subdir = 'HPXMLtoOpenStudio'
      full_measure_path = File.join(measures_dir, measure_subdir, 'measure.rb')
      check_file_exists(full_measure_path, runner)
      measure = get_measure_instance(full_measure_path)

      # Fill the measure args hash with default values
      measure_args = {}

      measures[measure_subdir] = []
      measure_args[:hpxml_path] = File.expand_path('../in.xml')
      measure_args[:weather_dir] = File.expand_path('../../../../weather')
      measure_args[:output_dir] = File.expand_path('..')
      measure_args[:debug] = false
      measure_args = Hash[measure_args.collect{ |k, v| [k.to_s, v] }]
      measures[measure_subdir] << measure_args

      if not apply_measures(measures_dir, measures, runner, unit_model, workflow_json, unit_name, true)
        return false
      end

      unit_models << unit_model
    end

    # TODO: merge all unit models into a single model
    model.getBuilding.remove
    model.getShadowCalculation.remove
    model.getSimulationControl.remove
    model.getSite.remove
    model.getTimestep.remove

    unit_models.each do |unit_model|
      model.addObjects(unit_model.objects, true)
    end

    return true
  end
end

# register the measure to be used by the application
BuildResidentialModel.new.registerWithApplication
