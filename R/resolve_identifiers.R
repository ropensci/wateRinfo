
#' Translate the usage of measurement station identifiers in the user interface
#' and the required variable to the corresponding timeseriesID
#'
#'
resolve_timeseriesid <- function(station, variable, format = "json") {
    station_variables <- #custom call... TODO
    station_variables %>% filter() # check if specific column is wanted variable
}


#' Translate the usage of available variables to the corresponding
#' timeseriesgroupID, based on the provided lookup table from VMM
#'
#' Remark that this information is NOT based on a query, but on information
#' provided by the package itself;
#'
#' The lookup table is provided as external data of the package,
#' see inst/extdata
#'
#' @param variable_name valid variable name, supported by VMM API
#' @param frequency valid frequency for the given variable
#'
#' @export
#' @importFrom dplyr %>% filter select
resolve_timeseriesgroupid <- function(variable_name, frequency = "15min") {

    lookup_file <- system.file("extdata", "lookup_timeseriesgroup",
                               package = "wateRinfo")
    lookup_file <- "./inst/extdata/lookup_timeseriesgroup"
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    selected_variable <- lookup %>%
        filter(variable_en == variable_name | variable_nl == variable_name)

    if (nrow(selected_variable) == 0) {
        stop('The provided variable is not available. ',
             'Supported variables as timeseriesgroup are: ',
             paste(supported_variables("en")$variable_en, collapse = ", "))
    }

    selected_variable <- selected_variable %>%
        filter(frequency_nl == frequency | frequency_en == frequency)

    if (nrow(selected_variable) == 0) {
        stop('The provided frequency for this variable is not available. ',
             'Supported frequencies for this variable are: ',
             paste(supported_frequencies(variable_name), collapse = ", "))
    }

    if (nrow(selected_variable) > 1 ) {
        stop('The provided combination of variable and frequence can not
             unambigiously be linked to a single timeseriesgroupid')
    }

    selected_variable %>%
        select(timeseriesgroup_id) %>%
        as.list()
}
