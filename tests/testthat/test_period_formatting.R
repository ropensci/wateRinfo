context("formatting of the period arguments")

test_that("VMM tutorial valid examples", {
    expect_equal(check_period_format("P3D"), "P3D")
    expect_equal(check_period_format("P1Y"), "P1Y")
    expect_equal(check_period_format("P1DT12H"), "P1DT12H")
    expect_equal(check_period_format("PT6H"), "PT6H")
    expect_equal(check_period_format("P1Y6M3DT4H20M30S"), "P1Y6M3DT4H20M30S")
})

test_that("days and week info can not be combined", {
    expect_error(check_period_format("P2W2D"))
    expect_equal(check_period_format("P2WT12H"), "P2WT12H")
})

test_that("Periods are defined by P symbol", {
    expect_error(check_period_format("3D"))
})

test_that("Periods need at least a time definition", {
    expect_error(check_period_format("P"))
})

test_that("Time definitions are preceded by number", {
    expect_error(check_period_format("PY"))
    expect_equal(check_period_format("P3Y"), "P3Y")
    expect_error(check_period_format("P3YM"))
    expect_equal(check_period_format("P3Y4M"), "P3Y4M")
    expect_error(check_period_format("P3Y4MD"))
    expect_equal(check_period_format("P3Y4M5D"), "P3Y4M5D")
    expect_error(check_period_format("P3Y4M5DTH"))
    expect_equal(check_period_format("P3Y4M5DT3H"), "P3Y4M5DT3H")
    expect_error(check_period_format("P3Y4M5DT4HM"))
    expect_equal(check_period_format("P3Y4M5DT4H3M"), "P3Y4M5DT4H3M")
    expect_error(check_period_format("P3Y4M5DT4H3MS"))
    expect_equal(check_period_format("P3Y4M5DT4H3M2S"), "P3Y4M5DT4H3M2S")
})

test_that("Subday information requires the T symbol are defined by P symbol", {
    # Actually the first example will work in waterinfo API, but this is rather
    # inconsistent from the API side and the docs of VMM says otherwise
    expect_error(check_period_format("P3H"))
    expect_error(check_period_format("P3H"))
    expect_equal(check_period_format("PT3H"), "PT3H")
    expect_equal(check_period_format("PT3M"), "PT3M")
})

test_that("Impossible date/period input combinations", {
    expect_error(parse_period(from = "2012-11-01",
                              to = "2013-12-01",
                              period = "P3D")) # all filled in
    expect_error(parse_period(from = NULL, to = NULL,
                              period = NULL)) # None filled in
    expect_error(parse_period(from = NULL, to = "2017/01/01",
                              period = NULL)) # only to used
    expect_is(parse_period(from = "2012-11-01", to = "2013-12-01"),
              class = "list")
    expect_is(parse_period(from = "2012-11-01", period = "P3D"),
              class = "list")
    expect_is(parse_period(to = "2012-11-01", period = "P3D"),
              class = "list")
})

test_that("Proper date formats to accept", {
    expect_is(check_date_format("2017-01-01 11:00:00"),
              class = c("POSIXct", "POSIXt"))
    expect_is(check_date_format("2017-01-01"), class = c("POSIXct", "POSIXt"))
    expect_is(check_date_format("2017/01/01"), class = c("POSIXct", "POSIXt"))
    expect_is(check_date_format("20170101"), class = c("POSIXct", "POSIXt"))
    expect_is(check_date_format("2017 01 01"), class = c("POSIXct", "POSIXt"))
    expect_is(check_date_format("2017-01"), class = c("POSIXct", "POSIXt"))
    expect_is(check_date_format("2017"), class = c("POSIXct", "POSIXt"))
    expect_false(isdatetime("01/01/2017"))
    expect_false(isdatetime("01-01-2017"))
})
