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

class Location
  def self.apply(model, runner, weather, epw_file, hpxml)
    apply_year(model, hpxml)
    apply_site(model, epw_file)
    apply_dst(model, hpxml)
    apply_ground_temps(model, weather)
  end

  def self.apply_weather_file(model, runner, weather_file_path, weather_cache_path)
    if File.exist?(weather_file_path) && weather_file_path.downcase.end_with?('.epw')
      epw_file = OpenStudio::EpwFile.new(weather_file_path)
    else
      fail "'#{weather_file_path}' does not exist or is not an .epw file."
    end

    OpenStudio::Model::WeatherFile.setWeatherFile(model, epw_file).get

    # Obtain weather object
    # Load from cache .csv file if exists, as this is faster and doesn't require
    # parsing the weather file.
    if File.exist? weather_cache_path
      weather = WeatherProcess.new(nil, nil, weather_cache_path)
    else
      weather = WeatherProcess.new(model, runner)
    end

    return weather, epw_file
  end

  private

  def self.apply_site(model, epw_file)
    site = model.getSite
    site.setName("#{epw_file.city}_#{epw_file.stateProvinceRegion}_#{epw_file.country}")
    site.setLatitude(epw_file.latitude)
    site.setLongitude(epw_file.longitude)
    site.setTimeZone(epw_file.timeZone)
    site.setElevation(epw_file.elevation)
  end

  def self.apply_year(model, hpxml)
    year_description = model.getYearDescription
    year_description.setCalendarYear(hpxml.header.sim_calendar_year)
  end

  def self.apply_dst(model, hpxml)
    return unless hpxml.header.dst_enabled

    month_names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    dst_start_date = "#{month_names[hpxml.header.dst_begin_month - 1]} #{hpxml.header.dst_begin_day}"
    dst_end_date = "#{month_names[hpxml.header.dst_end_month - 1]} #{hpxml.header.dst_end_day}"

    run_period_control_daylight_saving_time = model.getRunPeriodControlDaylightSavingTime
    run_period_control_daylight_saving_time.setStartDate(dst_start_date)
    run_period_control_daylight_saving_time.setEndDate(dst_end_date)
  end

  def self.apply_ground_temps(model, weather)
    # Shallow ground temperatures only currently used for ducts located under slab
    sgts = model.getSiteGroundTemperatureShallow
    sgts.resetAllMonths
    sgts.setAllMonthlyTemperatures(weather.data.GroundMonthlyTemps.map { |t| UnitConversions.convert(t, 'F', 'C') })

    # Deep ground temperatures used by GSHP setpoint manager
    dgts = model.getSiteGroundTemperatureDeep
    dgts.resetAllMonths
    dgts.setAllMonthlyTemperatures([UnitConversions.convert(weather.data.AnnualAvgDrybulb, 'F', 'C')] * 12)
  end

  def self.get_climate_zones
    zones_csv = File.join(File.dirname(__FILE__), 'data_climate_zones.csv')
    if not File.exist?(zones_csv)
      fail 'Could not find data_climate_zones.csv'
    end

    return zones_csv
  end

  def self.get_climate_zone_iecc(wmo)
    zones_csv = get_climate_zones

    require 'csv'
    CSV.foreach(zones_csv) do |row|
      return row[6].to_s if row[0].to_s == wmo.to_s
    end

    return
  end
end
