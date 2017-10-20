
waterinfo_base <- function() "http://download.waterinfo.be/tsmdownload/KiWIS/KiWIS"
waterinfo_pro_base <- function() "http://pro.waterinfo.be/tsmpro/KiWIS/KiWIS"

#' Basic http call to waterinfo.be, providing error handling and json parsing
#'
#' @param query list of query options to be used together with the base string
#' @param base_url str download | pro, default download defined
#'
#' @return waterinfo_api class object with content and info about call
#'
#' @export
#' @importFrom httr GET http_type status_code http_error content
#' @importFrom jsonlite fromJSON
call_waterinfo <- function(query, base_url = "download") {

    # check the base url, which depends of the query to execute
    if (base_url == "download") {
        base  = waterinfo_base()
    } else if (base_url == "pro") {
        base  = waterinfo_pro_base()
    } else {
        stop("Base url should be download or pro")
    }

    res <- GET(base, query = query)

    if (http_type(res) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }

    parsed <- fromJSON(content(res, "text"))

    if (http_error(res)) {
        stop(
            sprintf(
                "Waterinfo API request failed [%s]\nWaterinfo %s:
                %s\nWaterinfo return message: %s",
                status_code(res),
                parsed$type,
                parsed$code,
                parsed$message
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
#' @param ... args further arguments passed to or from other methods.
#'
#' @export
#'
print.waterinfo_api <- function(x, ...) {
    cat("Waterinfo API query applied: ", x$path, "\n", sep = "")
    str(x$content)
    invisible(x)
}
