
#' Get list of variables for a given station
#'
#' @param station_no 'stations-nummer' as it appears on the download page of
#' https://www.waterinfo.be/default.aspx?path=NL/Rapporten/Downloaden
#'
#' @return data.frame with the station_name, station_no, ts_id, ts_name  and
#' parametertype_name for each of the variables for this station
#' @export
get_variables <- function(station_no) {

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
    station_variables <- call_waterinfo(query = query_list, base_url = "pro")

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

    print(sprintf("Use datasource: %s for data requests of this station!",
                  datasource))

    df
}
