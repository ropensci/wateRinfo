#' Get waterinfo Token
#'
#' Retrieve a fresh waterinfo token.
#'
#' @aliases token print.token show.token expires.in expires.in.token is.expired
#' is.expired.token
#'
#' @param client base64 encoded client containing the client id and client
#' secret, seperated by :
#' @param client_id client id string
#' @param client_secret client secret string
#' @param token_url url to get the token from
#' @param token a token object
#'
#' @details Either client or client_id and client_secret need to be passed as
#' arguments. If provided, client is always used. Tokens remain valid for
#' 24 hours, after which a fresh one must be acquired.
#' To limit load on the server, token objects should be reused as much as
#' possible until expiration in stead of creating fresh ones for each call.
#' The client_id and client_secret provided in the examples are for test
#' purposes, get your very own client via \email{hydrometrie@@waterinfo.be}!
#'
#' @return An object of class token containing the token string with the
#' token_url, token type and moment of expiration as attributes.
#'
#' @examples
#' # Get token via client_id and client_secret
#' client_id <- '32dceece-826c-4b98-9c2d-b16978f0ca6a'
#' client_secret <- '4ada871a-9528-4b4d-bfd5-b570ce8f4d2d'
#' my.token <- get_token(client_id = client_id,client_secret = client_secret)
#' print(my.token)
#' # get token via client
#' client <- paste0('MzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhOjRhZGE4',
#'                 'NzFhLTk1MjgtNGI0ZC1iZmQ1LWI1NzBjZThmNGQyZA==')
#' my.token <- get_token(client = client)
#' print(my.token)
#' is.expired(my.token)
#' expires.in(my.token)
#'
#' @importFrom httr POST add_headers content
#' @importFrom openssl base64_encode
#' @export
get_token <- function(client = NULL, client_id = NULL, client_secret = NULL,
                token_url = 'http://download.waterinfo.be/kiwis-auth/token'){
  if (is.null(client)) {
    if (!is.null(client_id) & !is.null(client_secret)) {
      client <- base64_encode(paste(client_id,client_secret, sep = ":"))
    } else {
      stop('either client or client_id and client_secret must be provided')
    }
  } else {
    if (!is.null(client_id) | !is.null(client_secret)) {
      warning('both client and client_id and/or client_secret provided,
              using client')
    }
  }
  POST_call <- POST(url = token_url,
        config = add_headers(
            'Authorization' = paste0('Basic ', client),
            'scope' = 'none',
            'Content-Type' = 'application/x-www-form-urlencoded;charset=UTF-8'),
        body = 'grant_type=client_credentials')
  if (POST_call$status_code == 201) {
    out <- token(value = content(POST_call)$access_token,
                 url = token_url,
                 type = content(POST_call)$token_type,
                 expires = Sys.time() + content(POST_call)$expires_in)
    return(out)
  } else {
    stop(paste0('no token received, ', POST_call$url,
                ' returned status code: ', POST_call$status_code))
  }
}


token <- function(value, url, type, expires){
  if (!inherits(value,'character')) {
    if (length(value) != 1) {
      stop('value must be a character string')
    }
  }
  if (!inherits(url,'character')) {
    stop('url must be an url object')
  }
  if (!inherits(type,'character')) {
    if (length(type) != 1) {
      stop('type must be a character string')
    }
  }
  token <- structure(.Data = value, url = url, type = type,
                     expires = expires, class = 'token')
  return(token)
}


#' @export
print.token <- function(x,...) {
  cat('Token:\n', x, '\n\nAttributes:\n url: ', attr(x, 'url'), '\n type: ',
      attr(x, 'type'), '\n expires: ', format(attr(x, 'expires'), '%F %T %Z'),
      sep = '')
  invisible(x)
}


#' @export
show.token <- function(object) {
  print.token(object)
  invisible(object)
}


#' @rdname get_token
#' @export
is.expired <- function(token) {
  UseMethod("is.expired", token)
}


#' @export
is.expired.token <- function(token) {
  return(Sys.time() > attr(token, 'expires'))
}


#' @rdname get_token
#' @export
expires.in <- function(token) {
  UseMethod("expires.in", token)
}


#' @export
expires.in.token <- function(token) {
  return(attr(token,'expires') - Sys.time())
}
