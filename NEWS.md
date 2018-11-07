wateRinfo 0.2.1 (2018-10-17)
=============================

The `datasource` of the non-VMM stations changed recently (our tests on CI broke). Moreover, the 
`ts_identifiers` for these stations changed as well. Both are adaptations on the data source (waterinfo.be) level. 

### CRUCIAL QUICK FIX

* Change the datasource to 4 for non-VMM stations
* Adapt the examples and vignettes to existing `ts_identifiers`

wateRinfo 0.2.0 (2018-10-01)
=============================

### NEW FEATURES

* Better support for changed station identifiers of the waterinfo.be dataproviders 

### MINOR IMPROVEMENTS

* Change print statements for message statements
* Add missing test to check token object type (remark: current missing tests are hard to introduce without having control on the original API behaviour)
* Test files have consistent names
* Update code style using styler

### DOCUMENTATION FIXES

* Describe the table output format explicitly in roxygen docs and add the quality codes of the waterinfo.be dataproviders (#27)
* Update contributing guidelines, thanks to @peterdesmet who did a great effort on providing welcoming, clear written and engaging contributing guidelines
* Provide code examples for all public functions
* Provide top-level documentation handle `?wateRinfo` (#23)
* Add keywords internal of internal functions not part of the documentation index (#24)


wateRinfo 0.1.2 (2018-05-03)
============================

* Added a `NEWS.md` file to track changes to the package (#25).
* Provide support for parsible non-existing dates (e.g. '2018-04-31')
* Add contributing guidelines


wateRinfo 0.1.1 (2017-11-29)
============================

* Add support for token handling as distributed by waterinfo.be



