# wateRinfo

## Introduction

This R package aims to provide an easy R-interface to download time series data from [waterinfo.be](https://www.waterinfo.be/). An API is provided by the VMM to request time series data. However, this still requires the proper composition of the URL with the identification codes (`Timeseriesgroup_id`  and `ts_id`) as used by the system itself. To overcome this, this package aims to wrap these requests and provides some general R functions to request data.

