# URBANopt Example GeoJSON Project

## Version 0.11.0

## What's Changed
* Upgrade to OpenStudio 3.8 & Ruby 3.2 by @vtnate in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/197
* Ci tweaks by @vtnate in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/186
* Use feature 17 from UOv0.8.0 which uses hpxml workflow by @vtnate in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/187
* Support OpenStudio 3.7 by @vtnate in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/188
* Residential: allow one unit per floor by @joseph-robertson in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/194
* Upgrade to use Reopt v3 by @vtnate in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/195
* Residential: connect to ResStock by @joseph-robertson in https://github.com/urbanopt/urbanopt-example-geojson-project/pull/190


**Full Changelog**: https://github.com/urbanopt/urbanopt-example-geojson-project/compare/v0.10.0...v0.11.0

## Version 0.10.0

* Updated for OS 3.6.1

## Version 0.9.0

* OpenStudio 3.5.0
* HPXML v1.5.0

## Version 0.8.0

Date Range: 05/01/21 - 05/09/22:

* Update copyrights for 2021
* Ensure mappers are consistent with URBANopt CLI and add better error handling to baseline mapper
* Utilize ASHRAE 90.1 Laboratory prototype model
* Add new example PV feature file to example files folder
* Update example project to make use of commercial hours of operation customization
* Skip detailed model creation workflow if create bar workflow selected and detailed osm present
* Default the GCR (ground coverage ratio) for PV to 1 in all example assumptions files
* Add support for custom user HPXML files in example project
* update feature-file for electrical projects

## Version 0.7.0

* Updated dependencies to work with OpenStudio 3.3

## Version 0.6.0

* Updated dependencies to work with OpenStudio 3.2

## Version 0.5.0

* Updated dependencies to work with OpenStudio 3.1


## Version 0.3.0

* Updated dependencies to work with OpenStudio 3.x and Ruby 2.5.x


## Version 0.2.0

* Updated mappers to process project-level features (weather file, climate zone)
* Changes to what measures are run by default
* Updated mappers to process detailed model workflow and regular urbanopt workflow
* Updated mappers to handle DEER template and vintage
* Updated default project to run a full year
* Added comfort measure to base workflow

## Version 0.1.0

* Initial release of example project.
