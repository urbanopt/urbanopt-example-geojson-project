# URBANopt Example GeoJSON Project

[![Coverage Status](https://coveralls.io/repos/github/urbanopt/urbanopt-example-geojson-project/badge.svg?branch=develop)](https://coveralls.io/github/urbanopt/urbanopt-example-geojson-project?branch=develop)

## Overview

This example repository contains an URBANopt™ Example GeoJSON Project to demonstrate its basic principles.
It combines a set of URBANopt modules to implement a district-scale energy analysis
workflow. Each of these modules is developed and managed in separate source code
repositories. The different modules used in the URBANopt Example GeoJSON Project workflow
include:

- [URBANopt Core Gem](https://github.com/urbanopt/urbanopt-core-gem) defines the FeatureFile class.

- [URBANopt GeoJSON Gem](https://github.com/urbanopt/urbanopt-geojson-gem) has
  functionality to translate the GeoJSON Features to OpenStudio Models for simulation.

- [URBANopt Scenario Gem](https://github.com/urbanopt/urbanopt-scenario-gem)
  allows the user to specify, run and compare multiple district-scale energy scenarios.

- [URBANopt Reporting Gem](https://github.com/urbanopt/urbanopt-reporting-gem)
  generates the URBANopt results according to a consistent schema.

- [OpenStudio Common Measures Gem](https://github.com/NREL/openstudio-common-measures-gem) , [OpenStudio Model Articulation Gem](https://github.com/NREL/openstudio-model-articulation-gem) and
  [OpenStudio Standards Gem](https://github.com/NREL/openstudio-standards) modules are
  part of the OpenStudio SDK.

The
example project has different projects based on the geometry method used to create
buildings, such as the
`default project`, `createbar project` and the `floorspace project`.
There are commands to run, post process and delete these project described as
rake tasks within the
[Rakefile](https://github.com/urbanopt/urbanopt-example-geojson-project/blob/master/Rakefile).

More details on these projects and their implementation is described in the [Developer Documentation](https://urbanopt.github.io).


An overview of the commands:

*To view all rake tasks*

```ruby
bundle exec rake -T
```

**Running the projects**

*To run all projects and scenarios*

```ruby
bundle exec rake run_all
```

*To run a specific scenario for a project*

```ruby
bundle exec rake run_baseline[json,csv]
```

```ruby
bundle exec rake run_high_efficiency[json,csv]
```

```ruby
bundle exec rake run_mixed[json,csv]
```

Where, `json` is the name of the FeatureFile  `csv` is the name of the
scenario file corresponding to that feature file. For example, to  run the `createbar` project for
baseline scenario, use
the `example_project.json` as json and `createbar_scenario.csv` as csv.

*To run the thermal storage scenario*

```ruby
bundle exec rake run_thermal_storage[json,csv]
```

Where, `json` is the `example_project.json` FeatureFile and `csv` is the name of the
baseline, high efficiency or mixed csv for this feature file.

**Post-processing the projects**

*To post-process all projects and scenarios*

```ruby
bundle exec rake post_process_all[json,csv]
```
*To post-process a specific scenario for a project*


```ruby
bundle exec rake post_process_baseline[json,csv]
```
```ruby
bundle exec rake post_process_high_efficiency[json,csv]
```
```ruby
bundle exec rake post_process_mixed[json,csv]
```

Where, `json` is the is the name of the FeatureFile and  `csv` is the name of the scenario file
corresponding to the feature file, that you would like to post-process.

```ruby
bundle exec rake post_process_thermal_storage[json,csv]
```

Where, `json` is the `example_project.json` FeatureFile and `csv` is the name of a scenario file for this feature file.

**Visualizing post-processing results**

After running the post processing commands, the results of the post-processing can be visualized in
an html file.

*To visualize and compare features in a scenario*

```ruby
bundle exec rake visualize_features[scenario_file]
```
Where `scenario_file` is the name of the csv and dictates the scenario for which feature results are
visualized.

*To visualize and compare scenarios*

```ruby
bundle exec rake visualize_scenarios
```


**Clearing the projects**

*To clear all projects and scenarios*

```ruby
bundle exec rake clear_all[json,csv]
```

*To clear a specific scenario for a project*

```ruby
bundle exec rake clear_baseline[json,csv]
```

```ruby
bundle exec rake clear_high_efficiency[json,csv]
```

```ruby
bundle exec rake clear_mixed[json,csv]
```

Where, `json` is the is the name of the FeatureFile and  `csv` is the name of the scenario file
corresponding to the feature file, that you would like to clear.

```ruby
bundle exec rake clear_thermal_storage[json,csv]
```

Where, `json` is the `example_project.json` FeatureFile and `csv` is the name of a scenario file for this feature file.
