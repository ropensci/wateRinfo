


get_timeseries <- function(station, variable, period = NULL, from = NULL,
                           to = NULL, metadata = TRUE) {

    # resolve the identifier
    db_identifier <- resolve_timeseriesid(...)

    get_timeseries_tsid(db_identifier, period)
    return(df)
}


#' Get timeseries data from waterinfo.be, using the ts_id codes for a given
#' date period
#'
#'
#' @param ts_id waterinfo.be database ts_id, defining a timeserie variable and
#' frequency it is defined.
#' @param period input string according to format required by waterinfo:
#' De period string is provided as P#Y#M#DT#H#M#S, with P defines `Period`,
#' each # is an integer value and the codes define the number of...
#' Y - years
#' M - months
#' D - days
#' T required if information about sub-day resolution is present
#' H - hours
#' D - days
#' M - minutes
#' S - seconds
#' Instead of D (days), the usage of W - weeks is possible as well
#' Examples of valid period strings: P3D, P1Y, P1DT12H, PT6H, P1Y6M3DT4H20M30S.
#' @param from date of datestring as start of the time series
#' @param to date of datestring as end of the time series
#' @param metadata boolean provide metadata
#'
#' @return
#' @export
#'
#' @examples
#' get_timeseries_tsid("35055042", from="2017-01-01", to="2017-01-02")
get_timeseries_tsid <- function(ts_id, period = NULL, from = NULL,
                                to = NULL, metadata = TRUE) {
    # define the date fields we require
    return_fields <- c("Timestamp", "Value", "Quality Code")

    # check and handle the date/period information
    period_info <- parse_period(from, to, period)

    # general arguments
    query_list <- list(type = "queryServices", service = "kisters",
                       request = "getTimeseriesvalues",
                       ts_id = ts_id, format = "json",
                       datasource = "1",
                       returnfields = as.character(paste(return_fields,
                                                         collapse = ",")))

    # http GET call to waterinfo for the dataframe
    time_series <- call_waterinfo(query = c(query_list, period_info))
    df <- as.data.frame(time_series$content$data)

    # data formatting:
    df$X1 <- as.POSIXct(df$X1, format = "%Y-%m-%dT%H:%M:%S")
    df$X2 <- as.double(as.character(df$X2))
    colnames(df) <- strsplit(time_series$content$columns, ",")[[1]]
    return(df)
}
