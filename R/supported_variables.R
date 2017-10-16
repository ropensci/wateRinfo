#' Provide list of VMM supported variables in the timeseriesgroupID
#' in either dutch or english
#'
supported_variables <- function(language = "nl") {
    #lookup_file <- system.file("extdata", "lookup_timeseriesgroup",
    #                           package = "wateRinfo")
    lookup_file <- "./inst/extdata/lookup_timeseriesgroup"
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    if (language == "nl" ) {
        column_name <- "variable_nl"}
    else {
        column_name <- "variable_en"}

    lookup %>%
        select(column_name) %>%
        unique()
}


#' Provide list of VMM supported frequencies for a given timeseriesgroupID
#' in either dutch or english
#'
supported_frequencies <- function(variable_name) {
    #lookup_file <- system.file("extdata", "lookup_timeseriesgroup",
    #                           package = "wateRinfo")
    lookup_file <- "./inst/extdata/lookup_timeseriesgroup"
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    variable_subset <- lookup %>%
        filter(variable_en == variable_name | variable_nl == variable_name) %>%
        select(frequency_en)

    paste(variable_subset$frequency_en, collapse = ", ")
}
