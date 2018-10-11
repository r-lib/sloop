context("ftype")

test_that("functions return as expected", {
  f <- function(x) x
  expect_equal(ftype(f), "function")
  expect_equal(ftype(sum), c("primitive", "generic"))
  expect_equal(ftype(unlist), c("internal", "generic"))
})

test_that("various flavours of S3 return as expected", {
  expect_equal(ftype(t), c("S3", "generic"))
  expect_equal(ftype(t.data.frame), c("S3", "method"))
  expect_equal(ftype(t.test), c("S3", "generic"))
})

test_that("warns when trying to find S3 status of inline function", {
  expect_warning(ftype(function(x) x), "requires function name")
})

test_that("function can be both S3 generic and method", {
  f <- function(x) UseMethod("f")
  f.foo <- function(x) UseMethod("f.foo")

  expect_equal(ftype(f.foo), c("S3", "generic", "method"))
})

test_that("S4 methods and generics return as expected", {
  e <- attach(NULL, name = "test")
  on.exit(detach("test"))

  A <- setClass("A", contains = list(), where = e)

  setGeneric("f", function(x) 1, where = e)
  f <- getGeneric("f", where = e)
  expect_equal(ftype(f), c("S4", "generic"))

  setMethod("f", signature(x = "A"), function(x) 1, where = e)
  m <- getMethod("f", signature(x = "A"), where = e)
  expect_equal(ftype(m), c("S4", "method"))
})

test_that("RC methods return as expected", {
  B <- setRefClass("B", methods = list(f = function(x) x))
  b <- B$new()

  expect_equal(ftype(b$f), c("RC", "method"))
})
