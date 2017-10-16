
#' For a given station, provide a list of the available variables, i;e. the
#' variables and the precalculated frequencies for these variables
#'
get_variables <- function(station, format = "json") {

    station_variables <- call_waterinfo(
        query = list(type = "queryServices",
                     service = "kisters",
                     request = "getTimeseriesList",
                     ts_id = db_identifier,
                     datasource = 0,
                     format = format,
                     station_no = paste("01",
                                        station,
                                        sep = ""),
                     returnfields = c("station_name", "station_no", "ts_id",
                                      "ts_name", "stationparameter_name",
                                      "parametertype_name", "station_id")))
    station_variables
}
