
#' For a given timeseriesgroup (variable), provide a list of measurement
#' stations providing data for the given variable
#'
get_stations <- function(variable_name, frequency = "15min", format = "json") {

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
                     format = format,
                     metadata = TRUE, # essential to get additonal metadata fields
                     md_returnfields = as.character(paste(return_fields,
                                                          collapse = ",")),
                     custattr_returnfields = as.character(paste(custom_attributes,
                                                                collapse = ","))))
    stations$content %>% select(ts_id, station_latitude, station_longitude,
                                station_id, station_no, station_name,
                                parametertype_name, ts_unitsymbol)
}
