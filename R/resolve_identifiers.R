
#' Define the datasource using the station number
#'
#' Using the 'stations-nummer' as provided on
#' https://www.waterinfo.be/default.aspx?path=NL/Rapporten/Downloaden, this
#' function tries to identify the datasource to use for the particular variable
#'
#' Notice that VMM did not provide this in the official documentation, but this
#' has just been derived by checking the API response as such
#'
#' @param station_no 'stations-nummer' as it appears on the download page of
#' https://www.waterinfo.be/default.aspx?path=NL/Rapporten/Downloaden
#'
#' @return integer 1 for VMM, 2 for other meetnetten
#' @export
#'
#' @examples
#' resolve_datasource('akl03e-1066')
#' resolve_datasource('K07_OM421')
resolve_datasource <- function(station_no) {
    if (grepl(".*-1066", station_no)) {
        sprintf("Station %s belongs to Meetnet HIC", station_no)
        datasource <- 2
    } else if (grepl(".*-1072", station_no)) {
        sprintf("Station %s belongs to Meetnet De Vlaamse Waterweg - HIC",
                station_no)
        datasource <- 2
    } else if (grepl(".*-1073", station_no)) {
        sprintf("Station %s belongs to Meetnet EMT - afdeling Bovenschelde",
                station_no)
        datasource <- 2
    } else if (grepl(".*-1074", station_no)) {
        sprintf("Station %s belongs HIC",
                station_no)
        datasource <- 2
    } else if (grepl(".*-1095", station_no)) {
        sprintf("Station %s belongs to Meetnet W&Znv - afdeling Zeekanaal",
                station_no)
        datasource <- 2
    } else if (grepl(".*-1069", station_no)) {
        sprintf("Station %s belongs to Meetnet Vlaamse Banken",
                station_no)
        datasource <- 2
    } else {
        datasource <- 1
    }

    return(datasource)
}


#' Get timeseriesgroupID for a supported variable
#'
#' Translate the usage of available variables to the corresponding
#' timeseriesgroupID, based on the provided lookup table from VMM
#'
#' Remark that this information is NOT based on a query, but on information
#' provided by the package itself to make variable names more readable
#'
#' The lookup table is provided as external data of the package,
#' see inst/extdata
#'
#' @param variable_name valid variable name, supported by VMM API
#' @param frequency valid frequency for the given variable
#'
#' @export
#' @importFrom dplyr %>% filter_ select
#' @importFrom rlang .data
resolve_timeseriesgroupid <- function(variable_name, frequency = "15min") {

    is_supported_variable(variable_name)

    lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
                               package = "wateRinfo")
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    selected_variable <- lookup %>%
        filter(.data$variable_en == variable_name |
                   .data$variable_nl == variable_name)

    selected_variable <- selected_variable %>%
        filter(.data$frequency_nl == frequency |
                   .data$frequency_en == frequency)

    if (nrow(selected_variable) == 0) {
        stop("The provided frequency for this variable is not available. ",
             "Supported frequencies for this variable are: ",
             paste(supported_frequencies(variable_name), collapse = ", "))
    }

    selected_variable %>%
        select(.data$timeseriesgroup_id) %>%
        as.list()
}
