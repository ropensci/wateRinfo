context("token_usage")

test_that("token with id and secret", {
  client_id <- "32dceece-826c-4b98-9c2d-b16978f0ca6a"
  client_secret <- "4ada871a-9528-4b4d-bfd5-b570ce8f4d2d"
  my_token <- get_token(
    client_id = client_id,
    client_secret = client_secret
  )
  expect_is(my_token, "token")
  expect_is(is.expired(my_token), "logical")
  expect_is(expires.in(my_token), "difftime")

  stations <- get_stations("verdamping_monteith", token = my_token)
  expect_is(stations, "data.frame")
})


test_that("token as client id/secret combined", {
  client <- paste0(
    "MzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhOjRhZGE4",
    "NzFhLTk1MjgtNGI0ZC1iZmQ1LWI1NzBjZThmNGQyZA=="
  )
  my_token <- get_token(client)
  expect_is(my_token, "token")
  expect_is(is.expired(my_token), "logical")
  expect_is(expires.in(my_token), "difftime")

  stations <- get_stations("verdamping_monteith", token = my_token)
  expect_is(stations, "data.frame")
})


test_that("wrong combination of client information", {
  client <- paste0(
    "MzJkY2VlY2UtODI2Yy00Yjk4LTljMmQtYjE2OTc4ZjBjYTZhOjRhZGE4",
    "NzFhLTk1MjgtNGI0ZC1iZmQ1LWI1NzBjZThmNGQyZA=="
  )
  client_id <- "32dceece-826c-4b98-9c2d-b16978f0ca6a"
  client_secret <- "4ada871a-9528-4b4d-bfd5-b570ce8f4d2d"

  expect_error(get_token(client_id = client_id))
  expect_error(get_token(client_secret = client_secret))
  expect_warning(get_token(client, client_id, client_secret))
})

test_that("token should get proper inputs to instantiate", {
  value <- "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3YjFjMDA4Ni05ZDUyLTQzOTAtYTM"
  token_url <- "http://download.waterinfo.be/kiwis-auth/token"
  token_type <- "Bearer"
  expires <- as.POSIXct("2018-10-02 15:13:28 CEST")

  expect_is(token(value = value, url = token_url,
                  type = token_type, expires = expires), "token")
  expect_error(token(value = 123, url = token_url,
                     type = token_type, expires = expires))
  expect_error(token(value = c("a", "ab"), url = token_url,
                     type = token_type, expires = expires))
  expect_error(token(value = value, url = 123,
                     type = token_type, expires = expires))
  expect_error(token(value = value, url = token_url,
                     type = 123, expires = expires))
  expect_error(token(value = value, url = token_url,
                     type = c("a", "ab"), expires = expires))
})

test_that("Print output of token is data type specific", {
  value <- "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3YjFjMDA4Ni05ZDUyLTQzOTAtYTM"
  token_url <- "http://download.waterinfo.be/kiwis-auth/token"
  token_type <- "Bearer"
  expires <- as.POSIXct("2018-10-02 15:13:28 CEST", tz = "CEST")

  token_info <- c("Token:",
                  "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3YjFjMDA4Ni05ZDUyLTQzOTAtYTM",
                  "",
                  "Attributes:",
                  " url: http://download.waterinfo.be/kiwis-auth/token",
                  " type: Bearer",
                  " expires: 2018-10-02 15:13:28 CEST")

  token <- token(value = value, url = token_url,
                 type = token_type, expires = expires)
  message <- capture.output(print(token))
  show <- capture.output(show(token))

  expect_equal(c(message), token_info)
})

