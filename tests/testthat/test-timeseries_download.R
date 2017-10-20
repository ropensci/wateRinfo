context("timeseries_download")

test_that("works as expected", {
    #skip_on_cran()

    pressure <- get_timeseries_tsid("78124042",
                                    from = "2017-04-01",
                                    to = "2017-04-02")

    expect_is(pressure, "data.frame")
    expect_equal(colnames(pressure),
                 c("Timestamp", "Value", "Quality Code"))
})
