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
