# URBANopt Example GeoJSON Project

## Overview

This repository contains an URBANopt™ Example GeoJSON Project to demonstrate its basic principles.
It combines a set of URBANopt modules to implement a district-scale energy analysis
workflow. Each of these modules is developed and managed in separate source code
repositories. The different modules used in the URBANopt Example GeoJSON Project workflow
include:

- [URBANopt Core Gem](https://github.com/urbanopt/urbanopt-core-gem) defines the FeatureFile class.

- [URBANopt GeoJSON Gem](https://github.com/urbanopt/urbanopt-geojson-gem) has
  functionality to translate the GeoJSON Features to OpenStudio Models for simulation.

- [URBANopt Scenario Gem](https://github.com/urbanopt/urbanopt-scenario-gem)
  allows the user to specify, run and compare multiple district-scale energy scenarios.

- [OpenStudio Common Measures Gem](https://github.com/NREL/openstudio-common-measures-gem) , [OpenStudio Model Articulation Gem](https://github.com/NREL/openstudio-model-articulation-gem) and
  [OpenStudio Standards Gem](https://github.com/NREL/openstudio-standards) modules are
  part of the OpenStudio SDK.

The usage and implementation of the project is described in the [Developer Documentation](https://urbanopt.github.io).
