
#' Get list of variables for a given station
#'
#' @param station_no 'stations-nummer' as it appears on the download page of
#' https://www.waterinfo.be/default.aspx?path=NL/Rapporten/Downloaden
#' @param token token to use with the call (optional, can be retrieved via
#' \code{\link{get_token}})
#'
#' @return data.frame with the station_name, station_no, ts_id, ts_name and
#' parametertype_name for each of the variables for this station.
#'
#' @format A data.frame with 6 variables:
#' \describe{
#'   \item{station_name}{Official name of the measurement station.}
#'   \item{station_no}{Station ID as provided on the waterinfo.be website.}
#'   \item{ts_id}{Unique timeseries identifier to access time series data
#'   corresponding to a combination of the station, measured variable and
#'   frequency.}
#'   \item{ts_name}{Timeseries identifier description name as provided by
#'   `waterinfo.be`.}
#'   \item{parametertype_name}{Measured variable description.}
#'   \item{stationparameter_name}{Station specific variable description.}
#' }
#'
#' @export
#'
#' @examples
#' variables_overpelt <- get_variables("ME11_002")
get_variables <- function(station_no, token = NULL) {

    # try to check the data source required to get the station info
    datasource <- resolve_datasource(station_no)

    # query arguments for the API request
    return_fields <- c("station_name", "station_no", "ts_id",
                       "ts_name", "parametertype_name",
                       "stationparameter_name")
    query_list <- list(type = "queryServices", service = "kisters",
                       request = "getTimeseriesList", format = "json",
                       datasource = datasource, station_no = station_no,
                       returnfields = as.character(paste(return_fields,
                                                         collapse = ",")))

    # http GET call to waterinfo for the dataframe
    station_variables <- call_waterinfo(query = query_list, base_url = "pro",
                                        token = token)

    if (length(station_variables$content) == 1 &&
        station_variables$content == "No matches.") {
        stop("No station with the name ", station_no,
             " could be identified by waterinfo API.")
    }

    stations <- station_variables$content
    if (dim(stations)[1] == 2) {
        df <- as.data.frame(t(stations[2:nrow(stations), ]))
        colnames(df) <- stations[1, ]

    } else {
        df <- as.data.frame(stations[2:nrow(stations), ])
        colnames(df) <- stations[1, ]
    }

    message(sprintf("Use datasource: %s for data requests of this station!",
                  datasource))

    df
}
