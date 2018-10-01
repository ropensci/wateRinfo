# wateRinfo 0.2.0

This minor release provides better support for station identifiers of the waterinfo.be dataproviders, although 
we experienced changes in station names/ids. 

Furthermore, a number of good practices from ropensci were adopted as as possible:

* Describe the table output format explicitly in roxygen docs and add the quality codes of the waterinfo.be dataproviders (#27)
* Add keywords internal of internal functions not part of the documentation index (#24)
* Provide top-level documentation handle `?wateRinfo` (#23)
* Change print statements for message statements
* Add missing test to check token object type (remark: current missing tests are hard to introduce without having control on the original API behaviour)
* Test files have consistent names
* Update contributing guidelines, thanks to @peterdesmet who did a great effort on providing welcoming, clear written and engaging contributing guidelines
* Provide code examples for all public functions
* Update code style using styler

# wateRinfo 0.1.2

* Added a `NEWS.md` file to track changes to the package (#25).
* Provide support for parsible non-existing dates (e.g. '2018-04-31')
* Add contributing guidelines

# wateRinfo 0.1.1

* Add support for token handling as distributed by waterinfo.be



