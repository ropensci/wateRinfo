context("waterinfo_call")

test_that("base url is valid", {
    query <- list()
    expect_error(call_waterinfo(query, base_url = "www"),
                 regexp = "Base url should be download or pro")
})

test_that("wrong token object", {
  query <- list()
  expect_error(call_waterinfo(query, token = "3AGZ"),
               regexp = "Token should have proper object type"
  )
})

test_that("non existing tsid to API", {
    query <- list(type = "queryServices", service = "kisters",
                  request = "getTimeseriesvalues",
                  ts_id = "notsid", format = "json")
    expect_error(call_waterinfo(query),
                 regexp = "Waterinfo API request failed.*InvalidParameterValue")
})
