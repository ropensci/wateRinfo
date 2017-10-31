
<!-- README.md is generated from README.Rmd. Please edit that file -->
wateRinfo
=========

[![Build Status](https://travis-ci.org/stijnvanhoey/wateRinfo.svg?branch=addci)](https://travis-ci.org/stijnvanhoey/wateRinfo) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/stijnvanhoey/wateRinfo?branch=master&svg=true)](https://ci.appveyor.com/project/stijnvanhoey/wateRinfo) [![Coverage Status](https://coveralls.io/repos/github/stijnvanhoey/wateRinfo/badge.svg?branch=master)](https://coveralls.io/github/stijnvanhoey/wateRinfo?branch=master)

The goal of wateRinfo is to facilitate access to the variety of data available on [waterinfo.be](https://www.waterinfo.be/) by providing an R-interface to download time series data.

An [API](https://www.waterinfo.be/download/9f5ee0c9-dafa-46de-958b-7cac46eb8c23?dl=0) is provided by waterinfo.be to request time series data. However, this still requires the proper composition of the URL with the identification codes (`Timeseriesgroup_id` and `ts_id`) as used by the system itself. To facilitate the user in searching for stations and variables and consequently download the data of interest, this package provides some general R functions to download the `waterinfo.be` data.

Installation
------------

You can install wateRinfo from github with:

``` r
# install.packages("devtools")
devtools::install_github("stijnvanhoey/wateRinfo")
```

when succesfull, load it as usual:

``` r
library(wateRinfo)
```

Example
-------

For a number of supported variables ([documented](https://www.waterinfo.be/download/9f5ee0c9-dafa-46de-958b-7cac46eb8c23?dl=0) by VMM), the stations providing time series data for a given variable can be listed with the command `get_stations`.

If you want to know the supported variables, ask for the supported variables:

``` r
supported_variables('en')
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
```

Listing the available air\_pressure stations:

``` r
get_stations('air_pressure')
#>      ts_id station_latitude station_longitude station_id station_no
#> 1 78124042         51.20300          5.439589      12213   ME11_002
#> 2 78039042         51.24379          4.266912      12208   ME04_001
#> 3 78005042         51.02263          2.970584      12206   ME01_003
#> 4 78107042         51.16224          4.845708      12212   ME10_011
#> 5 78073042         50.88663          4.094898      12210   ME07_006
#> 6 78022042         51.27226          3.728299      12207   ME03_017
#> 7 78056042         50.86149          3.411318      12209   ME05_019
#> 8 78090042         50.73795          5.141976      12211   ME09_012
#>              station_name stationparameter_name parametertype_name
#> 1             Overpelt_ME                    Pa                 Pa
#> 2              Melsele_ME                    Pa                 Pa
#> 3               Zarren_ME                    Pa                 Pa
#> 4            Herentals_ME                    Pa                 Pa
#> 5           Liedekerke_ME                    BP                 Pa
#> 6            Boekhoute_ME                    Pa                 Pa
#> 7              Waregem_ME                    Pa                 Pa
#> 8 Niel-bij-St.-Truiden_ME                    Pa                 Pa
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

``` r
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

``` r
library(ggplot2)
ggplot(overpelt_pressure, aes(x = Timestamp, y = Value)) + 
    geom_line() + 
    xlab("") + ylab("hPa") + 
    scale_x_datetime(date_labels = "%H:%M\n%Y-%m-%d", date_breaks = "6 hours")
```

<img src="./figures/README-plot_pressure-1.png" width="80%" />

Another option is to check the available variables for a given station, with the function `get_variables`. Let's consider again Overpelt (`ME11_002`) and check the first ten available variables at the Overpelt measurement station:

``` r
vars_overpelt <- get_variables("ME11_002")
#> [1] "Use datasource: 1 for data requests of this station!"
head(vars_overpelt, 10)
#>    station_name station_no    ts_id                    ts_name
#> 1   Overpelt_ME   ME11_002 78118042                 KalJaarMin
#> 2   Overpelt_ME   ME11_002 96256042 Penman.IWRS.DagTotaal.8:00
#> 3   Overpelt_ME   ME11_002 78693042                       P.15
#> 4   Overpelt_ME   ME11_002 78522042                 HydJaarMax
#> 5   Overpelt_ME   ME11_002 90366042                 HydJaarMax
#> 6   Overpelt_ME   ME11_002 78804042                 KalJaarMax
#> 7   Overpelt_ME   ME11_002 78797042                     DagGem
#> 8   Overpelt_ME   ME11_002 78523042                 HydJaarMin
#> 9   Overpelt_ME   ME11_002 94682042                   MaandMin
#> 10  Overpelt_ME   ME11_002 78382042                     DagGem
#>    parametertype_name stationparameter_name
#> 1                  Pa                    Pa
#> 2                 PET                   pET
#> 3                  Ud                  WDir
#> 4                  Ts                 SoilT
#> 5                  Ta             Ta(1.75m)
#> 6                  Td                    Td
#> 7                  Td                    Td
#> 8                  Ts                 SoilT
#> 9                  Ta                    Ta
#> 10                 RH                    RH
```

Different pre-calculated variables are already available and a `ts_id` value is available for each of them to download the corresponding data. For example, `DagGem` (= daily mean values) of `RH` (= relative humidity), i.e. `ts_id = 78382042`:

``` r
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

``` r
ggplot(overpelt_rh_daily, aes(x = Timestamp, y = Value)) + 
    geom_line() + 
    xlab("") + ylab(" RH (%)") + 
    scale_x_datetime(date_labels = "%b-%d\n%Y", date_breaks = "5 days")
```

<img src="./figures/README-plot_rh-1.png" width="80%" />

Unfortunately, not all variables are documented, for which the check for the appropriate variable is not (yet) fully supported by the package.

More detailed tutorials are available in the package vignettes!

Tokens and restrictions of the downloads
----------------------------------------

The amount of data downloaded from waterinfo.be is limited via a credit system. When you require more extended data requests, please request a download token from the waterinfo.be site administrators via the e-mail adress <hydrometrie@waterinfo.be> with a statement of which data and how frequently you would like to download data. You will then receive a client-credit code that can be used to obtain a token that is valid for 24 hours, after which the token can be refreshed with the same client-credit code.

Get token with client-credit code: (limited client-credit code for testing purposes)
``` r
client <- 'MzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhOjRhZGE4NzFhLTk1MjgtNGI0ZC1iZmQ1LWI1NzBjZThmNGQyZA=='
my.token <- get_token(client=client)
print(my.token)
#> Token:
#> eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxZDc3Nzc0OC0xZWZmLTQxZTMtOTNmNS01ZDE5MjA3MzIxYTEiLCJpYXQiOjE1MDk0NTk5OTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9LaVdlYlBvcnRhbC9hdXRoIiwiYXVkIjoiMzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhIiwiZXhwIjoxNTA5NTQ2MzkzfQ.L1UHEC9MPHk0GcUEeMQkL5nc6RNgPAEvXuE3p2zzaEI
#> 
#> Attributes:
#>  url: http://download.waterinfo.be/kiwis-auth/token
#>  type: Bearer
#>  expires: 2017-11-01 15:26:33 CET
is.expired(my.token)
#>  FALSE
expires.in(my.token)
#> Time difference of 23.87589 hours
```
Use token when retrieving data:
``` r
get_stations(variable_name='verdamping_monteith',token=my.token)
#>      ts_id station_latitude station_longitude station_id station_no            station_name stationparameter_name
#> 1 94310042         51.02263          2.970584      12206   ME01_003               Zarren_ME                   pET
#> 2 94530042         51.16224          4.845708      12212   ME10_011            Herentals_ME                   pET
#> 3 94516042         50.73795          5.141976      12211   ME09_012 Niel-bij-St.-Truiden_ME                   pET
#> 4 94544042         51.20300          5.439589      12213   ME11_002             Overpelt_ME                   pET
#> 5 94488042         50.86149          3.411318      12209   ME05_019              Waregem_ME                   pET
#> 6 94460042         51.27226          3.728299      12207   ME03_017            Boekhoute_ME                   pET
#> 7 94502042         50.88663          4.094898      12210   ME07_006           Liedekerke_ME                   pET
#> 8 94474042         51.24379          4.266912      12208   ME04_001              Melsele_ME                   pET
  parametertype_name ts_unitsymbol dataprovider
1                PET            mm          VMM
2                PET            mm          VMM
3                PET            mm          VMM
4                PET            mm          VMM
5                PET            mm          VMM
6                PET            mm          VMM
7                PET            mm          VMM
8                PET            mm          VMM
```

Acknowledgements
----------------

This package is just a small wrapper around waterinfo.be to facilitate researchers and other stakeholders in downloading the data from [waterinfo.be](http://www.waterinfo.be). The availability of this data is made possible by *de Vlaamse Milieumaatschappij, Waterbouwkundig Laboratorium, Maritieme Dienstverlening & Kust, Waterwegen en Zeekanaal NV en De Scheepvaart NV*.

Furthermore...
--------------

This package is an experimental open-source project. All functionalities are provided as is, without any guarantee.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

Please [report any issues or bugs](https://github.com/stijnvanhoey/wateRinfo/issues/new).
