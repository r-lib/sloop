#' Compute the implicit S3 class of a base type
#'
#' @param x A primitive type
#' @export
#' @examples
#' implicit_class(NULL)
#'
#' implicit_class(logical())
#' implicit_class(integer())
#' implicit_class(numeric())
#' implicit_class(character())
#'
#' implicit_class(matrix())
#' implicit_class(matrix(1))
#'
#' implicit_class(array())
#' implicit_class(array(1))
implicit_class <- function(x) {
  if (is.object(x)) {
    stop("x is not a primitive type", call. = FALSE)
  }

  c(
    if (is.matrix(x)) "matrix",
    if (is.array(x) && !is.matrix(x)) "array",
    typeof(x),
    if (is.integer(x) || is.double(x)) "numeric"
  )
}
