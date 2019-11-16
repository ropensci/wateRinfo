
waterinfo_base <- function() {
  "https://download.waterinfo.be/tsmdownload/KiWIS/KiWIS"
  # "https://www.waterinfo.be/tsmpub/KiWIS/KiWIS"
}
waterinfo_pro_base <- function() {
  "https://pro.waterinfo.be/tsmpro/KiWIS/KiWIS"
}
hic_base <- function() {
  "https://www.waterinfo.be/tsmhic/KiWIS/KiWIS"
}

#' http call to waterinfo.be
#'
#' General call used to request information and data from waterinfo.be,
#' providing error handling and json parsing
#'
#' @param query list of query options to be used together with the base string
#' @param base_url str vmm | hic | pro, default download defined
#' @param token token to use with the call (optional, can be retrieved via
#' \code{\link{get_token}})
#'
#' @return waterinfo_api class object with content and info about call
#'
#' @keywords internal
#'
#' @importFrom httr GET http_type status_code http_error content add_headers
#' @importFrom jsonlite fromJSON
call_waterinfo <- function(query, base_url = "vmm", token = NULL) {

  hic_base

  # check the base url, which depends of the query to execute
  if (base_url == "vmm") {
    base <- waterinfo_base()
  } else if (base_url == "hic") {
    base <- hic_base()
  } else if (base_url == "pro") {
    base <- waterinfo_pro_base()
  } else {
    stop("Base url should be vmm, hic or pro")
  }

  if (is.null(token)) {
    res <- GET(base, query = query)
  } else {
    if (inherits(token, "token")) {
      res <- GET(base,
        query = query,
        config = add_headers(
          "Authorization" = paste0(
            attr(token, "type"),
            " ", token
          )
        )
      )
    } else {
      stop("Token must be object of class token, retrieve a token
                 via function get.token")
    }
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
#' @importFrom utils str
print.waterinfo_api <- function(x, ...) {
  cat("Waterinfo API query applied: ", x$path, "\n", sep = "")
  str(x$content)
  invisible(x)
}
