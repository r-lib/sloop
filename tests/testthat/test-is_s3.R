context("test-is_s3")

test_that("works with internal and regular generics", {
  expect_true(is_s3_generic("sum"))
  expect_true(is_s3_generic("[["))
  expect_true(is_s3_generic("mean"))
})
