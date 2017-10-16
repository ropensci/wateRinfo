
waterinfo_base <- function() "http://download.waterinfo.be/tsmdownload/KiWIS/KiWIS"

#' Basic http call to waterinfo.be, providing error handling and json parsing
#'
#' @param query list of query options to be used together with the base string
#'
#' @return waterinfo_api class object with content and info about call
#'
#' @export
#' @importFrom httr GET http_type status_code http_error content
#' @importFrom jsonlite fromJSON
call_waterinfo <- function(query) {
    res <- GET(waterinfo_base(), query = query)

    if (http_type(res) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }

    parsed <- fromJSON(content(res, "text"))

    if (http_error(res)) {
        stop(
            sprintf(
                "Waterinfo API request failed [%s]\n%s\n<%s>",
                status_code(res),
                parsed$message,
                parsed$documentation_url
            ),
            call. = FALSE
        )
    }

    structure(
        list(
            content = parsed,
            path = strsplit(res$url, "\\?")[[1]][2],
            response = res
        ),
        class = "waterinfo_api"
    )
}


#' Custom print function of the API request response
#'
#' @param x waterinfo_api
#' @param ...
#'
#' @export
#'
print.waterinfo_api <- function(x, ...) {
    cat("Waterinfo API query applied: ", x$path, "\n", sep = "")
    str(x$content)
    invisible(x)
}
