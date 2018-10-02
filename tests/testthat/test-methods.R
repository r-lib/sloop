context("test-methods")

test_that("regression tests", {
  expect_output_file(
    print(s3_methods_class("Date")),
    test_path("test-methods-class.txt")
  )

  expect_output_file(
    print(s3_methods_generic("anova")),
    test_path("test-methods-generic.txt")
  )
})
