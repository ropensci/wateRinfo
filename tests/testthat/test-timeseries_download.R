context("timeseries_download")

test_that("Call works as expected", {
    skip_on_cran()

    pressure <- get_timeseries_tsid("78124042",
                                    from = "2017-04-01",
                                    to = "2017-04-02")

    expect_is(pressure, "data.frame")
    expect_equal(colnames(pressure),
                 c("Timestamp", "Value", "Quality Code"))
    expect_is(pressure$Timestamp, c("POSIXct", "POSIXt"))
    expect_is(pressure$Value, c("numeric"))
})


test_that("Response of empty dataframe", {
    skip_on_cran()

    pressure <- get_timeseries_tsid("78124042",
                                    from = "1970-04-01",
                                    to = "1970-04-02")

    expect_is(pressure, "data.frame")
    expect_equal(colnames(pressure),
                 c("Timestamp", "Value", "Quality Code"))
    expect_equal(nrow(pressure), 0)
})
