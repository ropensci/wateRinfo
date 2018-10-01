#' VMM supported timeseriesgroups variables
#'
#' Provide list of VMM supported variables in the timeseriesgroupID
#' in either dutch or english
#'
#' @param language char \code{nl} (dutch) or \code{en} (english) variable names
#'
#' @return data.frame containing the variable names in either english or dutch
#'
#' @export
#' @importFrom dplyr select %>%
#' @importFrom utils read.csv
#' @importFrom rlang quo
#'
#' @examples
#' # Request supported variables in Dutch
#' supported_variables("nl")
#'
#' # Request supported variables in English
#' supported_variables("en")
supported_variables <- function(language = "nl") {
  if (language == "nl") {
    column_name <- "variable_nl"
  } else if (language == "en") {
    column_name <- "variable_en"
  } else {
    stop("nl and en are the supported languages to present variable names")
  }

  lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
    package = "wateRinfo"
  )
  lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

  lookup %>%
    select(!!column_name) %>%
    unique()
}


#' Check if variable is supported by VMM ts group id
#'
#' @param variable_name char
#'
#' @return Raise error when variable is not supported directly, otherwise NULL
#'
#' @export
#' @importFrom dplyr %>% filter
#' @importFrom rlang .data
#'
#' @examples
#' is_supported_variable("wind_speed")
is_supported_variable <- function(variable_name) {
  lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
    package = "wateRinfo"
  )
  lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

  selected_variable <- lookup %>%
    filter(.data$variable_en == variable_name |
      .data$variable_nl == variable_name)

  if (nrow(selected_variable) == 0) {
    stop(
      "The provided variable is not available. ",
      "Supported variables as timeseriesgroup are: ",
      paste(supported_variables("en")$variable_en, collapse = ", ")
    )
  }
}


#' VMM supported timeseriesgroups frequencies
#'
#' Provide list of VMM supported frequencies for a given timeseriesgroupID
#' in either dutch or english
#'
#' @param variable_name char name of a valid variable in either dutch or english
#'
#' @export
#' @importFrom dplyr %>% filter select
#' @importFrom utils read.csv
#' @importFrom rlang .data
#'
#' @examples
#' supported_frequencies('rainfall')
supported_frequencies <- function(variable_name) {
  is_supported_variable(variable_name)

  lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
    package = "wateRinfo"
  )
  lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

  variable_subset <- lookup %>%
    filter(.data$variable_en == variable_name |
      .data$variable_nl == variable_name)

  paste(variable_subset$frequency_en, collapse = ", ")
}
