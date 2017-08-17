#' Compute the S3 class of an object
#'
#' Compared to [class()], this always returns the class vector that is
#' used for dispatch. This is most important for objects where the
#' class attribute has not been set.
#'
#' @param x A primitive type
#' @export
#' @examples
#' s3_class(NULL)
#'
#' s3_class(logical())
#' s3_class(integer())
#' s3_class(numeric())
#' s3_class(character())
#'
#' s3_class(matrix())
#' s3_class(matrix(1))
#'
#' s3_class(array())
#' s3_class(array(1))
s3_class <- function(x) {
  if (is.object(x)) {
    class(x)
  } else {
    c(
      dim_class(x),
      lang_class(x),
      base_class(x),
      if (is.integer(x) || is.double(x)) "numeric"
    )
  }
}

dim_class <- function(x) {
  d <- length(dim(x))

  if (d == 0) {
    character()
  } else if (d == 2) {
    "matrix"
  } else {
    "array"
  }
}

lang_class <- function(x) {
  if (typeof(x) == "language") {
    setdiff(class(x), "call")
  } else {
    character()
  }
}

# Basically mode, but don't mess with numeric and integer
base_class <- function(x) {
  type <- typeof(x)
  switch(type,
    language = "call",
    closure = ,
    builtin = ,
    special = "function",
    symbol = "name",
    type
  )
}
