context("waterinfo_call")

test_that("base url is valid", {
    query <- list()
    expect_error(call_waterinfo(query, base_url = "www"),
                 regexp = "Base url should be download or pro")
})

test_that("wrong token object", {
  query <- list()
  expect_error(call_waterinfo(query, token = "3AGZ"))
})

test_that("non existing tsid to API", {
    query <- list(type = "queryServices", service = "kisters",
                  request = "getTimeseriesvalues",
                  ts_id = "notsid", format = "json")
    expect_error(call_waterinfo(query),
                 regexp = "Waterinfo API request failed.*InvalidParameterValue")
})

test_that("add call to waterinfo explicitly to the print output", {
  skip_on_cran()

  query <- list(type = "queryServices", service = "kisters",
                request = "getTimeseriesvalues",
                ts_id = "5156042", format = "json", datasource = 1)
  response <- call_waterinfo(query)
  raw_call_info <- "Waterinfo API query applied: type=queryServices&service=kisters&request=getTimeseriesvalues&ts_id=5156042&format=json&datasource=1"
  expect_equal(capture.output(print(response))[1], raw_call_info)


})



