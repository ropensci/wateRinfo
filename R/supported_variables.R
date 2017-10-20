#' Provide list of VMM supported variables in the timeseriesgroupID
#' in either dutch or english
#'
#' @param language char nl (dutch) or en (english) variable names
#'
#' @export
#' @importFrom dplyr select %>%
#' @importFrom utils read.csv
#' @importFrom rlang quo
supported_variables <- function(language = "nl") {
    lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
                               package = "wateRinfo")
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    if (language == "nl" ) {
        column_name <- quo(variable_nl)
        }
    else {
        column_name <- quo(variable_en)
        }

    lookup %>%
        select(!!column_name) %>%
        unique()
}


#' Provide list of VMM supported frequencies for a given timeseriesgroupID
#' in either dutch or english
#'
#' @param variable_name char name of a valid variable in either dutch or english
#'
#' @export
#' @importFrom dplyr %>% filter select
#' @importFrom utils read.csv
#' @importFrom rlang .data
supported_frequencies <- function(variable_name) {
    lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
                               package = "wateRinfo")
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    variable_subset <- lookup %>%
        filter(.data$variable_en == variable_name |
                   .data$variable_nl == variable_name)

    paste(variable_subset$frequency_en, collapse = ", ")
}
