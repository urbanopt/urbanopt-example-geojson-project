# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

# start the measure
class CoolingSetpointsHourlyAdjustedByDegrees < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'CoolingSetpointsHourlyAdjustedByDegrees'
  end

  # human readable description
  def description
    return 'Cooling Setpoints Hourly Adjusted by Degrees. Determines optimal cooling temperature ranges for load shaping of baseline load to meet the demand response of the target load
'
  end

  # human readable description of modeling approach
  def modeler_description
    return 'Cooling Setpoints Hourly Adjusted by Degrees. Determines optimal cooling temperature ranges for load shaping of baseline load to meet the demand response of the target load'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    # cooling setpoint to be applied for selected hour
    cooling_setpoint = OpenStudio::Ruleset::OSArgument::makeDoubleArgument('cooling_setpoint', true)
    cooling_setpoint.setDisplayName('Cooling Setpoint')
    cooling_setpoint.setDescription('Cooling Temperature Setpoint in Degrees Celsius')
    args << cooling_setpoint
		
    # hour of the day for cooling setpoint value
    hour_of_the_day = OpenStudio::Ruleset::OSArgument::makeDoubleArgument('hour_of_the_day', true)
    hour_of_the_day.setDisplayName('Hour of the Day')
    hour_of_the_day.setDescription('Hour of the Day for Specified Cooling Setpoint')
    args << hour_of_the_day

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
		cooling_setpoint = runner.getDoubleArgumentValue('cooling_setpoint',user_arguments)

		#input test
		if cooling_setpoint < 21.1
			runner.registerError('Cooling setpoint temperature (#{cooling_setpoint}) is less than 21.1 degrees Celsius')
			return false
		elsif cooling_setpoint.abs > 26.0
			runner.registerError('Cooling setpoint temperature (#{cooling_setpoint}) is greater than 26.0 degrees Celsius')
			return false
		end

		hour_of_the_day = runner.getDoubleArgumentValue('hour_of_the_day',user_arguments)

		#input test
		if hour_of_the_day < 1
			runner.registerError('Hour of the day (#{hour_of_the_day}) is less than 1')
			return false
		elsif hour_of_the_day.abs > 24
			runner.registerError('Hour of the day (#{hour_of_the_day}) is greater than 24')
			return false
		end

		starting_hour = hour_of_the_day - 1
		ending_hour = hour_of_the_day
		
		puts "*************************************************"
		puts "Starting Hour = #{starting_hour}"
		puts "Ending Hour = #{}"
		puts "*************************************************"

		#push schedules to hash to avoid making unnecessary duplicates
		clg_set_schs = {}
		

		#get thermostats and setpoint schedules
		thermostats = model.getThermostatSetpointDualSetpoints
		thermostats.each do |thermostat|
		  #setup new cooling setpoint schedule
		  clg_set_sch = thermostat.coolingSetpointTemperatureSchedule
		  if not clg_set_sch.empty?
		    # clone of not alredy in hash
		    if clg_set_schs.has_key?(clg_set_sch.get.name.to_s)
		      clg_set_sch = clg_set_schs[clg_set_sch.get.name.to_s]
		    else
		      clg_set_sch = clg_set_sch.get
		      #add to the hash
		      clg_set_schs[clg_set_sch.name.to_s] = clg_set_sch
		    end
		  else
		    runner.registerWarning("Thermostat '#{thermostat.name.to_s}' doesn't have a cooling setpoint schedule")
		  end #end if not clg_set_sch.empty?
		end #end thermostats.each do

	    #consider issuing a warning if the model has un-conditioned thermal zones (no ideal air loads or hvac)
	    zones = model.getThermalZones
	    zones.each do |zone|
	      # if you have a thermostat but don't have ideal air loads or zone equipment then issue a warning
	      if not zone.thermostatSetpointDualSetpoint.empty? and not zone.useIdealAirLoads and not zone.equipment.size > 0
	        runner.registerWarning("Thermal zone '#{zone.name.to_s}' has a thermostat but does not appear to be conditioned.")
	      end
	    end

	    # make cooling schedule adjustments and rename. Put in check to skip and warn if schedule not ruleset
	    clg_set_schs.each do |k,v| #old name and new object for schedule
	      if not v.to_ScheduleRuleset.empty?

	        #array to store profiles in
	        profiles = []
	        schedule = v.to_ScheduleRuleset.get
	        runner.registerInfo("Modifiying ScheduleRuleset #{schedule.name.to_s}")
					puts ""
					puts "Modifiying ScheduleRuleset #{schedule.name.to_s}"

	        #push default profiles to array
	        default_rule = schedule.defaultDaySchedule
	        profiles << default_rule

	        #push profiles to array
	        rules = schedule.scheduleRules
	        rules.each do |rule|
	          day_sch = rule.daySchedule
	          profiles << day_sch
	        end

	        # #add design days to array
	        # if alter_design_days == true
	        #   summer_design = schedule.summerDesignDaySchedule
	        #   winter_design = schedule.winterDesignDaySchedule
	        #   profiles << summer_design
	        #   #profiles << winter_design
	        # end

	        profiles.each do |sch_day|
						runner.registerInfo("    Modifiying ScheduleDay #{sch_day.name.to_s}")
						puts ""
						puts "    Modifiying ScheduleDay #{sch_day.name.to_s}"

		        day_time_vector = sch_day.times
		        day_value_vector = sch_day.values
		        # puts day_time_vector
		        # puts day_value_vector
		        sch_day.clearValues
						
						starting_hour_included = false
						ending_hour_included = false
						
						# determine if/where new data pairs need to be inserted
						for i in 0..(day_time_vector.size - 1)
							# get day time compenents
							# day_time_day = day_time_vector[i].days
							# runner.registerInfo("Date_time_day = #{day_time_day} for #{}")
							# unless day_time_day == 0
							# 	runner.registerError("Not expecting non-zero days value in schedule day #{sch_day.name}")
							# 	return false
							#end
							
							day_time_day = day_time_vector[i].days
							day_time_hour = day_time_vector[i].hours
							day_time_min = day_time_vector[i].minutes
							day_time_sec = day_time_vector[i].seconds
							day_time = day_time_day*24.0 + day_time_hour.to_f + day_time_min.to_f/60.0 + day_time_sec.to_f/3600.0
							puts ""
							puts "        Checking data pair: Time = #{day_time.round(2)}; Value = #{day_value_vector[i]}"
							
							# add/edit data pairs as necessary
							if day_time <= starting_hour
								puts "            Day time (#{day_time.round(2)}) is less than or equal to Starting hour (#{starting_hour})"
								# pass data pair back in as is
								sch_day.addValue(day_time_vector[i], day_value_vector[i])
								puts "            Adding data pair as is: Time = #{day_time_vector[i]}; Value = #{day_value_vector[i]}"
								if day_time == starting_hour
									starting_hour_included = true
								end
							else
								puts "            Day time (#{day_time.round(2)}) is greater than Starting hour (#{starting_hour})"
								unless starting_hour_included
									# add new data pair for starting hour
									# setpoint value should be whatever next baseline setpoint value is
									puts "            Adding a Starting Hour data pair: Time = #{starting_hour}; Value = #{day_value_vector[i]}"
									sch_day.addValue(OpenStudio::Time.new(0,starting_hour.to_i,0,0), day_value_vector[i])
									starting_hour_included = true
								end
								# determine if before or after ending hour
								if day_time <= ending_hour
									puts "            Day time (#{day_time.round(2)}) is less than or equal to Ending hour (#{ending_hour})"
									puts "            Adding data pair with specified Cooling Setpoint: Time = #{day_time_vector[i]}; Value = #{cooling_setpoint}"
									# swap in setpoint value argument
									sch_day.addValue(day_time_vector[i], cooling_setpoint)
									if day_time == ending_hour
										ending_hour_included = true
									end
								else
									puts "            Day time (#{day_time.round(2)}) is greater than Ending hour (#{ending_hour})"
									unless ending_hour_included
										# add new data pair for ending hour
										# setpoint value should be the setpoint value argument
										puts "            Adding an Ending Hour data pair with specified Cooling Setpoint: Time = #{ending_hour}; Value = #{cooling_setpoint}"
										# check for 24th hour case
										unless ending_hour.to_f == 24
											sch_day.addValue(OpenStudio::Time.new(0,ending_hour.to_i,0,0), cooling_setpoint)
										else	
											sch_day.addValue(OpenStudio::Time.new(1,0,0,0), cooling_setpoint)
										end	
										ending_hour_included = true
									end
									# pass data pair back in as is
									puts "            Adding data pair as is: Time = #{day_time_vector[i]}; Value = #{day_value_vector[i]}"
									sch_day.addValue(day_time_vector[i], day_value_vector[i])
								end
							end
						end						
	        end #end of profiles.each do
	      else
	        runner.registerWarning("Schedule '#{k}' isn't a ScheduleRuleset object and won't be altered by this measure.")
	        v.remove #remove un-used clone
	      end
	    end #end clg_set_schs.each do
		return true
	end
end

# register the measure to be used by the application
CoolingSetpointsHourlyAdjustedByDegrees.new.registerWithApplication
