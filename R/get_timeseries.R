
returnfields <- c("Timestamp", "Value", "Quality Code")

get_timeseries <- function(station, variable, period, format = "json",
                           metadata = TRUE) {

    # resolve the identifier
    db_identifier <- resolve_timeseriesid(...)

    # http GET call to waterinfo for the data itself
    call_waterinfo(query = list(type = "queryServices", service = "kisters",
                                request = "getTimeseriesvalues",
                                ts_id = db_identifier,
                                format = format,
                                period = period))

    response_parsed <- jsonlite::fromJSON(response$parse(encoding = "utf8"))
    df <- as.data.frame(data$data)

    df$X1 <- as.POSIXct(df$X1, format = "%Y-%m-%dT%H:%M:%S")
    df$X2 <- as.double(as.character(df$X2))
    colnames(df) <- stringr::str_split(data$columns, pattern = ",")[[1]]
    return(df)
}
