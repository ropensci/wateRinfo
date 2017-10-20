#' Air pressure data of January 1st, 2017
#'
#' A dataset compiled by downloading 1 day of air pressure data for the
#' available stations of Waterinfo.be
#'
#' @format A data frame with 710 rows and 13 variables:
#' \describe{
#'   \item{ts_id}{identifier of the downloaded time serie}
#'   \item{Timestamp}{datetime}
#'   \item{Value}{measured value of the variable}
#'   \item{Quality Code}{Quality code of the measurement}
#'   \item{station_latitude}{latitude coordinate}
#'   \item{station_longitude}{longitude coordinate}
#'   \item{station_id}{identifier of the measurement station}
#'   \item{station_no}{short code name of the measurement station}
#'   \item{station_name}{full name of the measurement station}
#'   \item{stationparameter_name}{parameter name on station level}
#'   \item{parametertype_name}{parameter type name}
#'   \item{ts_unitsymbol}{unit of the variable}
#'   \item{dataprovider}{provider of the time series value}
#' }
#' @source \url{https://www.waterinfo.be/}
"air_pressure"

#' Soil moisture data of Liedekerke, January 2017
#'
#' A dataset compiled by downloading 1 day of soil moisture data for the
#' Liedekerke  measurement station of Waterinfo.be
#'
#' @format A data frame with 23,816 rows and 9 variables:
#' \describe{
#'   \item{ts_id}{identifier of the downloaded time serie}
#'   \item{Timestamp}{datetime}
#'   \item{Value}{measured value of the variable}
#'   \item{Quality Code}{Quality code of the measurement}
#'   \item{station_name}{full name of the measurement station}
#'   \item{station_no}{short code name of the measurement station}
#'   \item{ts_name}{type/frequency of the time serie}
#'   \item{parametertype_name}{parameter type name}
#'   \item{stationparameter_name}{parameter name on station level}
#' }
#' @source \url{https://www.waterinfo.be/}
"liedekerke"
