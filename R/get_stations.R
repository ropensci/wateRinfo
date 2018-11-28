
#' Get list of stations for a variable
#'
#' For a given timeseriesgroup (variable), provide a list of measurement
#' stations providing data. An overview of the variables is provided by the
#' function \code{\link{supported_variables}}.
#'
#' For the moment, this only works for measurement stations of VMM (meetnet 1),
#' and stations from other measurement data sources are not included in the list
#'
#' @param variable_name char valid nam of available variable as timeseriesgroup
#' @param frequency char valid frequency for the given variable, for most
#' variables, the 15min frequency is available
#' @param token token to use with the call (optional, can be retrieved via
#' \code{\link{get_token}})
#'
#' @return data.frame with an overview of the available stations for the
#' requested variable
#'
#' @format A data.frame with 10 variables:
#' \describe{
#'   \item{ts_id}{Unique timeseries identifier to access time series data
#'   corresponding to a combination of the station, measured variable and
#'   frequency.}
#'   \item{station_latitude}{Latitude coordinates of the station (WGS84)}
#'   \item{station_longitude}{Longitude coordinates of the station (WGS84)}
#'   \item{station_id}{Identifier of the station as used in the waterinfo
#'   backend}
#'   \item{station_no}{Station ID as provided on the waterinfo.be website.}
#'   \item{station_name}{Official name of the measurement station.}
#'   \item{stationparameter_name}{Station specific variable description.}
#'   \item{parametertype_name}{Measured variable description.}
#'   \item{ts_unitsymbol}{Unit of the variable.}
#'   \item{dataprovider}{Data provider of the time series data.}
#' }
#'
#' @export
#' @importFrom dplyr %>% select
#'
#' @seealso supported_variables
#'
#' @examples
#' get_stations('irradiance')
#' get_stations('soil_saturation')
get_stations <- function(variable_name = NULL, frequency = "15min",
                         token = NULL) {
  if (is.null(variable_name)) {
    vars2use <- paste(as.list(supported_variables("en"))[[1]],
      collapse = ", "
    )
    stop("Please select a variable: ", vars2use, call. = FALSE)
  }

  timeseriesgroupid <- resolve_timeseriesgroupid(variable_name, frequency)

  custom_attributes <- c("dataprovider")
  return_fields <- c(
    "custom_attributes", "station_id", "station_no",
    "station_name", "stationparameter_name",
    "ts_unitsymbol", "parametertype_name", "ts_id"
  )

  stations <- call_waterinfo(
    query = list(
      type = "queryServices",
      service = "kisters",
      request = "getTimeseriesValueLayer",
      datasource = "1",
      timeseriesgroup_id = timeseriesgroupid$timeseriesgroup_id,
      format = "json",
      metadata = TRUE, # essential to get metadata fields
      md_returnfields = as.character(paste(return_fields,
        collapse = ","
      )),
      custattr_returnfields =
        as.character(paste(custom_attributes,
          collapse = ","
        ))
    ),
    token = token
  )

  df <- stations$content %>% select(
    "ts_id", "station_latitude",
    "station_longitude", "station_id",
    "station_no", "station_name",
    "stationparameter_name",
    "parametertype_name",
    "ts_unitsymbol",
    "dataprovider"
  )

  # add request URL as df comment
  comment(df) <- stations$response$url

  return(df)
}
