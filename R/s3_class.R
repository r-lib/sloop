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
    # Implicit class
    c(
      if (is.matrix(x)) "matrix",
      if (is.array(x) && !is.matrix(x)) "array",
      typeof(x),
      if (is.integer(x) || is.double(x)) "numeric"
    )
  }
}
