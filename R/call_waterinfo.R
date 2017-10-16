
library('httr')
library('jsonlite')

waterinfo_base <- function() "http://download.waterinfo.be/tsmdownload/KiWIS/KiWIS"

call_waterinfo <- function(query) {
    res <- GET(waterinfo_base(), query = query)

    if (http_type(res) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }

    parsed <- jsonlite::fromJSON(content(res, "text"))

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


print.waterinfo_api <- function(x, ...) {
    cat("Waterinfo API query applied: ", x$path, "\n", sep = "")
    str(x$content)
    invisible(x)
}
