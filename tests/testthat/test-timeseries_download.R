context("timeseries_download")

# This does not call the waterinfo API, but a stored version of the response
with_mock_API({
    test_that("Check time series dataframe output format", {

        pressure <- get_timeseries_tsid("78124042",
                                        from = "2017-04-01",
                                        to = "2017-04-02")

        expect_is(pressure, "data.frame")
        expect_equal(colnames(pressure),
                     c("Timestamp", "Value", "Quality Code"))
        expect_is(pressure$Timestamp, c("POSIXct", "POSIXt"))
        expect_is(pressure$Value, c("numeric"))
    })
})


test_that("Call works as expected", {
    skip_if_disconnected()
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
    skip_if_disconnected()
    skip_on_cran()

    pressure <- get_timeseries_tsid("78124042",
                                    from = "1970-04-01",
                                    to = "1970-04-02")

    expect_is(pressure, "data.frame")
    expect_equal(colnames(pressure),
                 c("Timestamp", "Value", "Quality Code"))
    expect_equal(nrow(pressure), 0)
})
