
def residential_template(args, template, climate_zone)
  '''Assign arguments from tsv files.'''

  # IECC / EnergyStar / Other
  if template.include?('Residential IECC')

    captures = template.match(/Residential IECC (?<iecc_year>\d+) - Customizable Template (?<t_month>\w+) (?<t_year>\d+)/)
    template_vals = Hash[captures.names.zip(captures.captures)]
    template_vals = template_vals.transform_keys(&:to_sym)
    template_vals[:climate_zone] = climate_zone

    # ENCLOSURE

    enclosure_filepath = File.join(File.dirname(__FILE__), 'iecc/enclosure.tsv')
    enclosure = get_lookup_tsv(args, enclosure_filepath)
    row = get_lookup_row(args, enclosure, template_vals)

    # Determine which surfaces to place insulation on
    if args[:geometry_foundation_type].include? 'Basement'
      row[:foundation_wall_assembly_r] = row[:foundation_wall_assembly_r_basement]
      row[:floor_over_foundation_assembly_r] = 2.1
      row[:floor_over_garage_assembly_r] = 2.1
    elsif args[:geometry_foundation_type].include? 'Crawlspace'
      row[:foundation_wall_assembly_r] = row[:foundation_wall_assembly_r_crawlspace]
      row[:floor_over_foundation_assembly_r] = 2.1
      row[:floor_over_garage_assembly_r] = 2.1
    end
    row.delete(:foundation_wall_assembly_r_basement)
    row.delete(:foundation_wall_assembly_r_crawlspace)
    if ['ConditionedAttic'].include?(args[:geometry_attic_type])
      row[:roof_assembly_r] = row[:ceiling_assembly_r]
      row[:ceiling_assembly_r] = 2.1
    end
    args.update(row) unless row.nil?

    # HVAC

    { args[:heating_system_type] => 'iecc/heating_system.tsv', 
      args[:cooling_system_type] => 'iecc/cooling_system.tsv',
      args[:heat_pump_type] => 'iecc/heat_pump.tsv' }.each do |type, path|

      if type != 'none'
        filepath = File.join(File.dirname(__FILE__), path)
        lookup_tsv = get_lookup_tsv(args, filepath)
        row = get_lookup_row(args, lookup_tsv, template_vals)
        args.update(row) unless row.nil?
      end
    end

    # APPLIANCES / MECHANICAL VENTILATION / WATER HEATER

    ['refrigerator', 'clothes_washer', 'dishwasher', 'clothes_dryer', 'mechanical_ventilation', 'water_heater'].each do |appliance|
      filepath = File.join(File.dirname(__FILE__), "iecc/#{appliance}.tsv")
      lookup_tsv = get_lookup_tsv(args, filepath)
      row = get_lookup_row(args, lookup_tsv, template_vals)
      args.update(row) unless row.nil?
    end
  end
end