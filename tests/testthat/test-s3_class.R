context("s3_class")

test_that("integer and double have final component", {
  expect_equal(s3_class(1:10), c("integer", "numeric"))
  expect_equal(s3_class(matrix(1.5, 1, 1)), c("matrix", "double", "numeric"))
  expect_equal(s3_class(array(1L, c(1, 1, 1))), c("array", "integer", "numeric"))
  expect_equal(s3_class(array(1L, 1)), c("array", "integer", "numeric"))
})

test_that("s3_class matches class for language objects", {
  expect_equal(s3_class(quote(x)), "name")
  expect_equal(s3_class(quote(1 + 2)), "call")
  expect_equal(s3_class(quote((1 + 2))), c("(", "call"))
  expect_equal(s3_class(quote({1 + 2})), c("{", "call"))
})

test_that("s3_class matches class for functions", {
  expect_equal(s3_class(function() {}), "function")
  expect_equal(s3_class(sum), "function")
  expect_equal(s3_class(`[`), "function")
})

test_that("calls class for S3 objects", {
  x <- ordered(character())
  expect_equal(s3_class(x), class(x))
})
