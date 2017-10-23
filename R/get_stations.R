
#' Get list of stations for a variable
#'
#' For a given timeseriesgroup (variable), provide a list of measurement
#' stations providing data. An overview of the variables is provided by the
#' function `supported_variables`
#'
#' For the moment, this only works for measurement stations of VMM (meetnet 1),
#' and stations from other measurement nets are not included in the list
#'
#' @param variable_name char valid nam of available variable as timeseriesgroup
#' @param frequency char valid frequency for the given variable, for most
#' variables, the 15min frequency is available
#'
#' @export
#' @importFrom dplyr %>% select
#' @seealso supported_variables
get_stations <- function(variable_name = NULL, frequency = "15min") {

    if (is.null(variable_name)) {
        vars2use <- paste(as.list(supported_variables("en"))[[1]],
                          collapse = ", ")
        stop("Please select a variable: ", vars2use, call. = FALSE)
    }

    timeseriesgroupid <- resolve_timeseriesgroupid(variable_name, frequency)

    custom_attributes <- c("dataprovider")
    return_fields <- c("custom_attributes", "station_id", "station_no",
                       "station_name", "stationparameter_name",
                       "ts_unitsymbol", "parametertype_name", "ts_id")

    stations <- call_waterinfo(
        query = list(type = "queryServices",
                     service = "kisters",
                     request = "getTimeseriesValueLayer",
                     datasource = "1",
                     timeseriesgroup_id = timeseriesgroupid$timeseriesgroup_id,
                     format = "json",
                     metadata = TRUE, # essential to get metadata fields
                     md_returnfields = as.character(paste(return_fields,
                                                          collapse = ",")),
                     custattr_returnfields =
                         as.character(paste(custom_attributes,
                                            collapse = ","))))

    stations$content %>% select("ts_id", "station_latitude",
                                "station_longitude", "station_id",
                                "station_no", "station_name",
                                "stationparameter_name",
                                "parametertype_name",
                                "ts_unitsymbol",
                                "dataprovider")
}
