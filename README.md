<!-- README.md is generated from README.Rmd. Please edit that file and knit -->



# wateRinfo <img src="man/figures/logo.png" align="right" alt="" width="120">

[![Build Status](https://travis-ci.org/ropensci/wateRinfo.svg?branch=addci)](https://travis-ci.org/ropensci/wateRinfo) [![Appveyor Build status](https://ci.appveyor.com/api/projects/status/crmofvs8c7oja0mn/branch/master?svg=true)](https://ci.appveyor.com/project/stijnvanhoey/waterinfo-agry3/branch/master) [![Coverage Status](https://coveralls.io/repos/github/ropensci/wateRinfo/badge.svg)](https://coveralls.io/r/ropensci/wateRinfo?branch=master)

wateRinfo facilitates access to [waterinfo.be](https://www.waterinfo.be/), a website managed by the [Flanders Environment Agency (VMM)](https://en.vmm.be/) and [Flanders Hydraulics Research](https://www.waterbouwkundiglaboratorium.be/). The website provides access to real-time water and weather related environmental variables for Flanders (Belgium), such as rainfall, air pressure, discharge, and water level. The package provides functions to search for stations and variables, and download time series.

To get started, see:

* [Function reference](https://ropensci.github.io/wateRinfo/reference/index.html): an overview of all wateRinfo functions.
* [Articles](https://ropensci.github.io/wateRinfo/articles/): tutorials on how to use the package.

## Installation

You can install wateRinfo from [GitHub](https://github.com/ropensci/wateRinfo) with:


```r
# install.packages("devtools")
devtools::install_github("ropensci/wateRinfo")
```

When succesfull, load it as usual:


```r
library(wateRinfo)
```

## Example

For a number of supported variables ([documented](https://www.waterinfo.be/download/9f5ee0c9-dafa-46de-958b-7cac46eb8c23?dl=0) by VMM), the stations providing time series data for a given variable can be listed with the command `get_stations`.

If you want to know the supported variables, ask for the supported variables:


```r
supported_variables("en")
#>              variable_en
#> 1              discharge
#> 6        soil_saturation
#> 7          soil_moisture
#> 8  dew_point_temperature
#> 9     ground_temperature
#> 10           ground_heat
#> 11            irradiance
#> 12          air_pressure
#> 13 air_temperature_175cm
#> 14              rainfall
#> 20     relative_humidity
#> 21  evaporation_monteith
#> 25    evaporation_penman
#> 29        water_velocity
#> 34           water_level
#> 39     water_temperature
#> 40        wind_direction
#> 41            wind_speed
```

Listing the available air_pressure stations:


```r
get_stations("air_pressure")
#>      ts_id station_latitude station_longitude station_id station_no
#> 1 78124042         51.20300          5.439589      12213   ME11_002
#> 2 78039042         51.24379          4.266912      12208   ME04_001
#> 3 78005042         51.02263          2.970584      12206   ME01_003
#> 4 78073042         50.88663          4.094898      12210   ME07_006
#> 5 78107042         51.16224          4.845708      12212   ME10_011
#> 6 78022042         51.27226          3.728299      12207   ME03_017
#> 7 78090042         50.73795          5.141976      12211   ME09_012
#> 8 78056042         50.86149          3.411318      12209   ME05_019
#>              station_name stationparameter_name parametertype_name
#> 1             Overpelt_ME                    Pa                 Pa
#> 2              Melsele_ME                    Pa                 Pa
#> 3               Zarren_ME                    Pa                 Pa
#> 4           Liedekerke_ME                    BP                 Pa
#> 5            Herentals_ME                    Pa                 Pa
#> 6            Boekhoute_ME                    Pa                 Pa
#> 7 Niel-bij-St.-Truiden_ME                    Pa                 Pa
#> 8              Waregem_ME                    Pa                 Pa
#>   ts_unitsymbol dataprovider
#> 1           hPa          VMM
#> 2           hPa          VMM
#> 3           hPa          VMM
#> 4           hPa          VMM
#> 5           hPa          VMM
#> 6           hPa          VMM
#> 7           hPa          VMM
#> 8           hPa          VMM
```

Each of the stations in the list for a given variable, are represented by a `ts_id`. These can be used to download the data of a given period with the command `get_timeseries_tsid`, for example Overpelt (`ts_id = 78124042`):


```r
overpelt_pressure <- get_timeseries_tsid("78124042", 
                                         from = "2017-04-01", 
                                         to = "2017-04-02")
head(overpelt_pressure)
#>             Timestamp  Value Quality Code
#> 1 2017-04-01 00:00:00 1008.8          130
#> 2 2017-04-01 00:15:00 1008.7          130
#> 3 2017-04-01 00:30:00 1008.7          130
#> 4 2017-04-01 00:45:00 1008.6          130
#> 5 2017-04-01 01:00:00 1008.5          130
#> 6 2017-04-01 01:15:00 1008.4          130
```

Making a plot of the data with ggplot:


```r
library(ggplot2)
ggplot(overpelt_pressure, aes(x = Timestamp, y = Value)) + 
    geom_line() + 
    xlab("") + ylab("hPa") + 
    scale_x_datetime(date_labels = "%H:%M\n%Y-%m-%d", date_breaks = "6 hours")
```

<img src="man/figures/README-plot_pressure-1.png" title="plot of chunk showplot1" alt="plot of chunk showplot1" width="80%" />

Another option is to check the available variables for a given station, with the function `get_variables`. Let's consider again Overpelt (`ME11_002`) and check the first ten available variables at the Overpelt measurement station:


```r
vars_overpelt <- get_variables("ME11_002")
head(vars_overpelt, 10)
#>    station_name station_no    ts_id    ts_name parametertype_name
#> 1   Overpelt_ME   ME11_002 96216042  DagTotaal         Noverschot
#> 2   Overpelt_ME   ME11_002 78663042   MaandGem                  U
#> 3   Overpelt_ME   ME11_002 78664042   MaandMax                  U
#> 4   Overpelt_ME   ME11_002 78667042       P.10                  U
#> 5   Overpelt_ME   ME11_002 78654042     DagGem                  U
#> 6   Overpelt_ME   ME11_002 78656042     DagMin                  U
#> 7   Overpelt_ME   ME11_002 78658042 HydJaarMax                  U
#> 8   Overpelt_ME   ME11_002 78668042       P.15                  U
#> 9   Overpelt_ME   ME11_002 78660042 KalJaarGem                  U
#> 10  Overpelt_ME   ME11_002 78661042 KalJaarMax                  U
#>    stationparameter_name
#> 1             Noverschot
#> 2                 WSpeed
#> 3                 WSpeed
#> 4                 WSpeed
#> 5                 WSpeed
#> 6                 WSpeed
#> 7                 WSpeed
#> 8                 WSpeed
#> 9                 WSpeed
#> 10                WSpeed
```

Different pre-calculated variables are already available and a `ts_id` value is available for each of them to download the corresponding data. For example, `DagGem` (= daily mean values) of `RH` (= relative humidity), i.e. `ts_id = 78382042`:


```r
overpelt_rh_daily <- get_timeseries_tsid("78382042", 
                                         from = "2017-04-01", 
                                         to = "2017-04-30")
head(overpelt_rh_daily)
#>             Timestamp Value Quality Code
#> 1 2017-04-01 23:00:00 80.19          130
#> 2 2017-04-02 23:00:00 89.58          130
#> 3 2017-04-03 23:00:00 79.56          130
#> 4 2017-04-04 23:00:00 84.13          130
#> 5 2017-04-05 23:00:00 84.19          130
#> 6 2017-04-06 23:00:00 82.71          130
```


```r
ggplot(overpelt_rh_daily, aes(x = Timestamp, y = Value)) + 
    geom_line() + 
    xlab("") + ylab(" RH (%)") + 
    scale_x_datetime(date_labels = "%b-%d\n%Y", date_breaks = "5 days")
```

<img src="man/figures/README-plot_rh-1.png" title="plot of chunk showplot2" alt="plot of chunk showplot2" width="80%" />

Unfortunately, not all variables are documented, for which the check for the appropriate variable is not (yet) fully supported by the package.

More detailed tutorials are available in the package vignettes!

## Note on restrictions of the downloads

The amount of data downloaded from waterinfo.be is limited via a credit system. You do not need to get a token right away to download data. For limited and irregular downloads, a token will not be required.

When you require more extended data requests, please request a download token from the waterinfo.be site administrators via the e-mail adress <hydrometrie@waterinfo.be> with a statement of which data and how frequently you would like to download data. You will then receive a client-credit code that can be used to obtain a token that is valid for 24 hours, after which the token can be refreshed with the same client-credit code.

Get token with client-credit code: (limited client-credit code for testing purposes)


```r
client <- paste0("MzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhOjRhZGE4",
                 "NzFhLTk1MjgtNGI0ZC1iZmQ1LWI1NzBjZThmNGQyZA==")
my_token <- get_token(client = client)
print(my_token)
#> Token:
#> eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3NjI2NzA4Yi0xNjdiLTRlZGMtOWI0OC01YmQ2MWY5ZDZmMmQiLCJpYXQiOjE1NTEyNzI4MjUsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9LaVdlYlBvcnRhbC9hdXRoIiwiYXVkIjoiMzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhIiwiZXhwIjoxNTUxMzU5MjI1fQ.ySiyJdkmwFf-hy9hNAGqWFqWiAG18go7fFje3T_8uYE
#> 
#> Attributes:
#>  url: http://download.waterinfo.be/kiwis-auth/token
#>  type: Bearer
#>  expires: 2019-02-28 14:07:05 CET
```

Receive information on the validity of the token:


```r
is.expired(my_token)
#> [1] FALSE
```

Check when the token expires:


```r
expires.in(my_token)
#> Time difference of 24 hours
```

Use token when retrieving data:


```r
get_stations(variable_name = "verdamping_monteith", token = my_token)
#>      ts_id station_latitude station_longitude station_id station_no
#> 1 94310042         51.02263          2.970584      12206   ME01_003
#> 2 94544042         51.20300          5.439589      12213   ME11_002
#> 3 94530042         51.16224          4.845708      12212   ME10_011
#> 4 94516042         50.73795          5.141976      12211   ME09_012
#> 5 94502042         50.88663          4.094898      12210   ME07_006
#> 6 94474042         51.24379          4.266912      12208   ME04_001
#> 7 94488042         50.86149          3.411318      12209   ME05_019
#> 8 94460042         51.27226          3.728299      12207   ME03_017
#>              station_name stationparameter_name parametertype_name
#> 1               Zarren_ME                   pET                PET
#> 2             Overpelt_ME                   pET                PET
#> 3            Herentals_ME                   pET                PET
#> 4 Niel-bij-St.-Truiden_ME                   pET                PET
#> 5           Liedekerke_ME                   pET                PET
#> 6              Melsele_ME                   pET                PET
#> 7              Waregem_ME                   pET                PET
#> 8            Boekhoute_ME                   pET                PET
#>   ts_unitsymbol dataprovider
#> 1            mm          VMM
#> 2            mm          VMM
#> 3            mm          VMM
#> 4            mm          VMM
#> 5            mm          VMM
#> 6            mm          VMM
#> 7            mm          VMM
#> 8            mm          VMM
```

## Acknowledgements

This package is just a small wrapper around waterinfo.be to facilitate researchers and other stakeholders in downloading the data from [waterinfo.be](http://www.waterinfo.be). The availability of this data is made possible by *de Vlaamse Milieumaatschappij, Waterbouwkundig Laboratorium, Maritieme Dienstverlening & Kust, Waterwegen en Zeekanaal NV en De Scheepvaart NV*.

## Meta

* We welcome [contributions](.github/CONTRIBUTING.md) including bug reports.
* License: MIT
* Get citation information for `wateRinfo` in R doing `citation("wateRinfo")`.
* Please note that this project is released with a [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
