
def get_resstock_building_id(args, buildstock_csv_path)
  '''Return ResStock building_id based on geojson file.'''

  # TODO

  resstock_building_id = 2 # FIXME: remove this line once this method actually assigns resstock_building_id
  return resstock_building_id
end

def residential_resstock(args, resstock_building_id, buildstock_csv_path)
  '''Assign resstock_building_id that points to buildstock_csv_path.'''

  args[:resstock_building_id] = resstock_building_id

  # Create lib folder (so we can more easily copy code from BuildExistingModel)
  res_measures_dir = File.absolute_path(File.join(File.dirname(__FILE__), '../../../resources/residential-measures'))
  lib_dir = File.join(res_measures_dir, 'lib')
  resources_dir = File.join(res_measures_dir, 'resources')
  housing_characteristics_dir = File.join(res_measures_dir, 'project_national/housing_characteristics')

  FileUtils.rm_rf(lib_dir)
  Dir.mkdir(lib_dir)
  FileUtils.cp_r(resources_dir, lib_dir)
  FileUtils.cp_r(housing_characteristics_dir, lib_dir)
  FileUtils.cp(buildstock_csv_path, File.join(housing_characteristics_dir, 'buildstock.csv'))
end    