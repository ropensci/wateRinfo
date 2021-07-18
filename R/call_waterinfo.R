
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
hydro_base <- function() {
  "https://hydro.vmm.be/grid/kiwis/KiWIS"
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
call_waterinfo <- function(
  query, base_url = c("vmm", "hic", "pro", "hydro"), token = NULL
) {
  # check the base url, which depends of the query to execute
  base_url <- match.arg(base_url)
  base <- switch(
    base_url, vmm = waterinfo_base(), hic = hic_base(),
    pro = waterinfo_pro_base(), hydro = hydro_base()
  )

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

  if (http_type(res) != "application/json") {
    if (http_type(res) == "text/xml") {
      custom_error <- content(res, "text", encoding = "UTF-8")

      pattern <- "(?<=ExceptionText>).*(?=</ExceptionText>)"
      error_message <- regmatches(
        custom_error,
        regexpr(pattern, custom_error,
                perl = TRUE
        ))
    }
    if (grep(pattern = "Credit limit exceeded", error_message) == 1) {
      error_message <- paste(error_message,
          "- When you require more extended data requests, please request",
          "a download token from the waterinfo.be site administrators via",
          "the e-mail address hydrometrie@waterinfo.be with a statement of",
          "which data and how frequently you would like to download data.",
          "Run `?wateRinfo::token` for more information on token usage.")
    }
    stop("API did not return json - ", trimws(error_message), call. = FALSE)
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
