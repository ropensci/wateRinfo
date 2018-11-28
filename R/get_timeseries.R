
#' Download timeseries data from waterinfo.be
#'
#' Using the ts_id codes  and by providing a given date period, download the
#' corresponding time series from the waterinfo.be website
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
#' @param datasource int [0-3] defines the `meetnet` of which the measurement
#' station is part of. VMM based stations are net '1', MOW-HIC is net '2'
#' @param token token to use with the call (optional, can be retrieved via
#' \code{\link{get_token}})
#'
#' @return data.frame with the timestamps, values and quality code
#'
#' @format A data.frame with 3 variables:
#' \describe{
#'   \item{Timestamp}{Datetime of the measurement.}
#'   \item{Value}{Measured value.}
#'   \item{Quality Code}{Quality code of the measurement, dependent on the
#'   data source used:
#'      \itemize{
#'         \item{VMM Quality Code Interpretation (datasource 1)
#'            \itemize{
#'               \item{10/110 - Excellent}
#'               \item{30/100/130 - Good}
#'               \item{50/150 - Moderate}
#'               \item{70/170 - Poor}
#'               \item{80/180 - Estimated}
#'               \item{90/190 - Suspect}
#'               \item{220 - Default}
#'               \item{-1 - Missing}
#'            }
#'         }
#'         \item{HIC Quality Code Interpretation (datasource 2)
#'            \itemize{
#'               \item{40 - Good}
#'               \item{80 - Estimated}
#'               \item{120 - Suspect}
#'               \item{200 - Unchecked}
#'               \item{60 - Complete}
#'               \item{160 - Incomplete}
#'               \item{-1 - Missing}
#'            }
#'         }
#'         \item{Aggregated timeseries
#'            \itemize{
#'               \item{40 - Good}
#'               \item{100 - Estimated}
#'               \item{120 - Suspect}
#'               \item{200 - Unchecked}
#'               \item{-1 - Missing}
#'            }
#'         }
#'      }
#'    }
#' }
#'
#' @export
#' @importFrom lubridate ymd_hms
#'
#' @examples
#' get_timeseries_tsid("35055042", from = "2017-01-01", to = "2017-01-02")
#' get_timeseries_tsid("5156042", period = "P3D")
#' get_timeseries_tsid("55419010", from = "2017-06-01", to = "2017-06-03",
#'                     datasource = 4)
get_timeseries_tsid <- function(ts_id, period = NULL, from = NULL,
                                to = NULL, datasource = 1, token = NULL) {
  # define the date fields we require
  return_fields <- c("Timestamp", "Value", "Quality Code")

  # check and handle the date/period information
  period_info <- parse_period(from, to, period)

  # general arguments
  query_list <- list(
    type = "queryServices", service = "kisters",
    request = "getTimeseriesvalues",
    ts_id = ts_id, format = "json",
    datasource = datasource,
    returnfields = as.character(paste(return_fields,
      collapse = ","
    ))
  )

  # http GET call to waterinfo for the dataframe
  time_series <- call_waterinfo(
    query = c(query_list, period_info),
    token = token
  )

  if (time_series$content$rows == 0) {
    df <- data.frame(
      Timestamp = as.POSIXct(character()),
      Value = double(),
      "Quality Code" = character(),
      stringsAsFactors = FALSE
    )
    colnames(df) <- return_fields
  } else {
    df <- as.data.frame(time_series$content$data,
      stringsAsFactors = FALSE
    )

    # data formatting:
    df$X1 <- ymd_hms(df$X1)
    df$X2 <- as.double(as.character(df$X2))
    colnames(df) <- strsplit(time_series$content$columns, ",")[[1]]
  }

  # add request URL as df comment
  comment(df) <- time_series$response$url

  return(df)
}
