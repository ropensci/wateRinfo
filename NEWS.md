wateRinfo 0.3.0.9047 (2018-12-13)
=============================

### NEW FEATURES

* WateRinfo moved to ropensci, thanks to @ldecicco-USGS for the review and @karthik for editing the submission

### MINOR IMPROVEMENTS

* Change the URLs to `https` version, which are now supported by waterinfo.be
* Make sure data.frame content are characters and not factors
* Return supported frequencies as vector instead of single ling character

### DOCUMENTATION FIXES

* Update to usage of pkgdown 1.3.0
* Moved link references from INBO tp ropensci
* Add ropensci footer
* Mark Institute of Nature and Forest Research (INBO) as copyright holder
* Updated logo base color

Notice, we will add an in-development fourth component to the release tag with the development version. For more information, see [package guide](http://r-pkgs.had.co.nz/description.html#version).

wateRinfo 0.2.2 (2018-11-07)
=============================

### CRUCIAL QUICK FIX

* When no `datasource` is added to the waterinfo.be query, the server gives a html/text response containing a tomcat server error messag. This error is now captured properly. As the user normally only uses the wrapped API call functions, there should no difference on the user level.

### DOCUMENTATION FIXES

* Bring documentation up to date with the new `datasource` handling

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



