#' Determine the type of an object
#'
#' Tells you if you're dealing with an base, S3, S4, RC, or R6 object.
#'
#' @param x An object
#' @export
#' @examples
#' otype(1:10)
#' otype(mtcars)
otype <- function(x) {
  if (!is.object(x)) {
    "base"
  } else if (!isS4(x)) {
    if (!inherits(x, "R6")) {
      "S3"
    } else {
      "R6"
    }
  } else {
    if (!is(x, "refClass")) {
      "S4"
    } else {
      "RC"
    }
  }
}
