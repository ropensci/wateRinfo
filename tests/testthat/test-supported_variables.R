context("supported_variables")

test_that("variables in en and nl", {
    vars_nl <- supported_variables("nl")
    vars_en <- supported_variables("en")

    expect_is(vars_nl, "data.frame")
    expect_is(vars_en, "data.frame")
    expect_true("afvoer" %in% vars_nl$variable_nl)
    expect_true("discharge" %in% vars_en$variable_en)
    expect_false("discharge" %in% vars_nl$variable_nl)
    expect_false("afvoer" %in% vars_en$variable_en)

})


test_that("variables in en and nl", {
    freqs <- supported_frequencies("afvoer")

    expect_is(freqs, "character")
    expect_true(grepl("15min", freqs))
})


test_that("datasource support of identifiers", {
    expect_equal(resolve_datasource(station_no = "xxxxxx-1066"), 2)
    expect_equal(resolve_datasource(station_no = "xxxxxx-1072"), 2)
    expect_equal(resolve_datasource(station_no = "xxxxxx-1073"), 2)
    expect_equal(resolve_datasource(station_no = "xxxxxx-1074"), 2)
    expect_equal(resolve_datasource(station_no = "xxxxxx-1095"), 2)
    expect_equal(resolve_datasource(station_no = "xxxxxx-1069"), 2)
    expect_equal(resolve_datasource(station_no = "xxxxxx"), 1)
})


test_that("extract tsgroup identifiers for variables", {
    expect_is(resolve_timeseriesgroupid("discharge")$timeseriesgroup_id,
              "integer")
    expect_is(resolve_timeseriesgroupid("rainfall")$timeseriesgroup_id,
              "integer")
})


test_that("handling when variable is not available", {
    expect_error(supported_frequencies("iamnotavariable"),
                 regexp = "The provided variable is not available")
    expect_error(is_supported_variable("iamnotavariable"),
                 regexp = "The provided variable is not available")
    expect_error(resolve_timeseriesgroupid("iamnotavariable"),
                 regexp = "The provided variable is not available")
})


test_that("handling when frequency for this var is not available", {
    expect_error(resolve_timeseriesgroupid("rainfall", "3.5min"),
                 regexp = "provided frequency .* is not available")
})

test_that("checking all ids are unique linked to var-freq combination", {

    lookup_file <- system.file("extdata", "lookup_timeseriesgroup.txt",
                               package = "wateRinfo")
    lookup <- read.csv(lookup_file, sep = " ", stringsAsFactors = FALSE)

    nl_ids <- lookup %>%
        select(variable_nl, frequency_nl) %>%
        duplicated() %>% sum()

    en_ids <- lookup %>%
        select(variable_en, frequency_en) %>%
        duplicated() %>% sum()

    expect_equal(nl_ids, 0)
    expect_equal(en_ids, 0)
})


test_that("handling when language is not available", {
    expect_error(supported_variables("iamnotalanguage"),
                 regexp = "nl and en are the supported languages")
})


