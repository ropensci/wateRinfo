

#' Check if the format of the period is conform the specifications of VMM
#'
#' @param period_string input string according to format required by waterinfo:
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
#'
#' @return
#' @export
check_period_format <- function(period_string) {
    regex <- paste("^P(?=[0-9]+|T)[0-9]*Y?(?!M)[0-9]*M?(?![DW])[0-9]*[D,W]?",
                   "(T)?(?(1)(?![H])[0-9]*H?(?![M])[0-9]*M?(?![S])[0-9]*S?|)$",
                   sep = "")
    valid <- grepl(regex, period_string, perl = TRUE)
    if (valid == FALSE) {
        stop("The period string is not a valid expression.
             Examples of valid expressions are:
             P3D, P1Y, P1DT12H, PT6H, P1Y6M3DT4H20M30S")
    }
    period_string
}

#' Check if the string input can be converted to a date
#' (acknowledgments to micstr/isdate.R)
#'
#'
#' @param datetime string representation of a date
#'
#' @return boolean
#' @export
#'
#' @examples
#' isdate("1985-11-21")
#'
#' @importFrom lubridate parse_date_time
isdatetime <- function(datetime) {
    tryCatch(parse_date_time(datetime,
                             orders = c("ymd_hms", "ymd", "ym", "y")),
             warning = function(err) {FALSE})
}


#' Check if the date can be parsed to a datetim object in R
#'
#' if the date is already a datetime object ("POSIXct" "POSIXt"), the object
#' itself is returned
#'
#' @param datetime string representation of the date
#'
#' @return
#' @export
check_date_format <- function(datetime) {
    date_parsed <- isdatetime(datetime)
    if (date_parsed == FALSE) {
        stop("The date string can not be properly parsed in any of the
             in any of the following formats: ymd_hms, ymd, ym, y)")
    }
    date_parsed
}

#' Handle the information of provided date information on the period and provide
#' feedback to the user
#'
#' valid combinations of the arguments are:
#' from/to, from/period, to/period, period, from
#'
#' @param from string representing date of datetime object
#' @param to string representing date of datetime object
#' @param period input string according to format required by waterinfo
#'
#' @seealso check_period_format
#' @return list with the relevant period/date information
parse_period <- function(from = NULL, to = NULL, period = NULL) {

    # if none of 3 provided, error
    if (is.null(from) & is.null(to) & is.null(period)) {
        stop('Date information should be provided by a combination of 2
             parameters out of from/to/period')
    }

    # if all 3 provided, error
    if (!is.null(from) & !is.null(to) & !is.null(period)) {
        stop('Date information should be provided by a combination of maximum 2
             parameters out of from/to/period')
    }

    # if only 'to' provided, error
    if (is.null(from) & !is.null(to) & is.null(period)) {
        stop('Date information should be provided by providing a from or period
             input')
    }

    period_info <- list()
    # convert the data-formats
    if (!is.null(from)) {
        from <- check_date_format(from)
        # Remark that VMM accepts just year as input for from, but we just
        # standardize it here, lubridate will translate to same moment
        period_info["from"] = strftime(from, "%y-%m-%d %H:%M:%S")
    }

    if (!is.null(to)) {
        to <- check_date_format(from)
        period_info["to"] = strftime(to, "%y-%m-%d %H:%M:%S")
    }

    if (!is.null(period)) {
        period <- check_period_format(period)
        period_info["period"] = period
    }

    return(period_info)
}
