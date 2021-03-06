context("variable_listing")

test_that("works as expected", {
  # skip_on_cran()

  overpelt <- get_variables("ME11_002")
  ostend <- get_variables(station_no = "OST-1069")

  expect_is(overpelt, "data.frame")
  expect_is(ostend, "data.frame")

  expect_is(comment(overpelt), "character")
  expect_true(grepl("https://pro.waterinfo.be/tsmpro/KiWIS/KiWIS",
                    comment(overpelt)))

  expect_true(78118042 %in% overpelt$ts_id)
  expect_true("ts_id" %in% colnames(overpelt))
  expect_true(55175010 %in% ostend$ts_id)
  expect_true("ts_id" %in% colnames(ostend))

  # all character data types
  expect_equal(prod(vapply(overpelt, is.character, TRUE)), 1)
  expect_equal(prod(vapply(overpelt, is.character, TRUE)), 1)

  expect_equal(
    colnames(overpelt),
    c(
      "station_name", "station_no", "ts_id",
      "ts_name", "parametertype_name", "stationparameter_name"
    )
  )
  expect_equal(colnames(ostend), colnames(overpelt))
})

test_that("unexisting station", {
  expect_error(get_variables("abracadabre"))
})
