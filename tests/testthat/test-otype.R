context("test-otype")

test_that("otype yields correct value for sample inputs", {
  expect_equal(otype(1:10), "base")
  expect_equal(otype(mtcars), "S3")
})
