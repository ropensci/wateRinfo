context("station_listing")


test_that("Check station list dataframe output format", {
  heat_stat <- get_stations("ground_heat")

  expect_is(heat_stat, "data.frame")

  expect_is(comment(heat_stat), "character")
  expect_true(grepl("https://download.waterinfo.be/tsmdownload/KiWIS/KiWIS",
                    comment(heat_stat)))

  expect_true(94385042 %in% heat_stat$ts_id)
  expect_false(85541042 %in% heat_stat$ts_id)
  expect_true("ts_id" %in% colnames(heat_stat))

  expect_equal(
    colnames(heat_stat),
    c(
      "ts_id", "station_latitude", "station_longitude",
      "station_id", "station_no", "station_name",
      "stationparameter_name", "parametertype_name",
      "ts_unitsymbol", "dataprovider"
    )
  )
})


test_that("Call works as expected", {
  skip_on_cran()

  heat_stat <- get_stations("ground_heat")

  expect_is(heat_stat, "data.frame")
  expect_true(94385042 %in% heat_stat$ts_id)
  expect_false(85541042 %in% heat_stat$ts_id)
  expect_true("ts_id" %in% colnames(heat_stat))

  expect_equal(
    colnames(heat_stat),
    c(
      "ts_id", "station_latitude", "station_longitude",
      "station_id", "station_no", "station_name",
      "stationparameter_name", "parametertype_name",
      "ts_unitsymbol", "dataprovider"
    )
  )
})


test_that("Handling absence of variable name", {
  expect_error(get_stations(NULL),
    regexp = "Please select a variable"
  )
})
