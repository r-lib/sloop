context("dispatch")

test_that("finds methods in other namespaces", {
  mod1 <- glm(mpg ~ wt, data = mtcars)

  out <- s3_dispatch(anova(mod1))
  expect_equal(out$method, c("anova.glm", "anova.lm", "anova.default"))
  expect_equal(out$exists, c(TRUE, TRUE, FALSE))
})

test_that("includes internal generics", {
  out <- s3_dispatch(length(1))
  expect_length(out$method, 4)
  expect_equal(out$method[[4]], "length (internal)")

  out <- s3_dispatch(length(structure(1, class = "integer")))
  expect_length(out$method, 3)
  expect_equal(out$method[[3]], "length (internal)")
})

test_that("includes group generics", {
  out <- s3_dispatch(-Sys.Date())
  expect_equal(out$method, c("-.Date", "-.default", "Ops.Date", "Ops.default", "- (internal)"))
  expect_equal(out$exists, c(TRUE, FALSE, TRUE, FALSE, TRUE))
})

test_that("has nice output", {
  expect_known_output(
    print(s3_dispatch(Sys.Date() + 1)),
    test_path("test-dispatch-print.txt")
  )

  expect_known_output(
    print(s3_dispatch(Sys.Date() * 1)),
    test_path("test-dispatch-print-nextmethod.txt")
  )
})
