context("station_listing")

test_that("works as expected", {
    #skip_on_cran()

    heat_stat <- get_stations("ground_heat")

    expect_is(heat_stat, "data.frame")
    expect_true(94385042 %in% heat_stat$ts_id)
    expect_false(85541042 %in% heat_stat$ts_id)
    expect_true('ts_id' %in% colnames(heat_stat))

    expect_equal(colnames(heat_stat),
                 c('ts_id', 'station_latitude', 'station_longitude',
                   'station_id', 'station_no', 'station_name',
                   'stationparameter_name', 'parametertype_name',
                   'ts_unitsymbol', 'dataprovider'))
})

