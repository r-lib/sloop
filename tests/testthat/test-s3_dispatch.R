context("s3_dispatch")

test_that("finds methods in other namespaces", {
  mod1 <- glm(mpg ~ wt, data = mtcars)

  out <- s3_dispatch(anova(mod1))
  expect_equal(out$method, c("anova.glm", "anova.lm", "anova.default"))
  expect_equal(out$exists, c(TRUE, TRUE, FALSE))
})

test_that("includes internal generics", {
  out <- s3_dispatch(length(1))
  expect_equal(out$method[4], "length")
  expect_equal(out$exists[4], TRUE)
})

test_that("includes group generics", {
  out <- s3_dispatch(-Sys.Date())
  expect_equal(out$method, c("-.Date", "-.default", "Ops.Date", "Ops.default", "-"))
  expect_equal(out$exists, c(TRUE, FALSE, TRUE, FALSE, TRUE))
})
