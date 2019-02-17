context("test-methods")

test_that("multiplication works", {
  registerS3method("sloop_foo", "blah", function(x) {}, envir = asNamespace("sloop"))

  out <- s3_methods_generic("sloop_foo")
  expect_equal(nrow(out), 1)
  expect_equal(out$generic, "sloop_foo")
  expect_equal(out$class, "blah")
})
