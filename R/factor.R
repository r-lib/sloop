#' Factor
#'
#' A `factor` is an integer with attribute levels. There should be one
#' level for each integer between 1 and `max(x)`. Note that `new_factor()` only
#' checks types; it does not assert that the values are a valid factor.
#'
#' @param x An integer vector
#' @param levels A character vector of levels
new_factor <- function(x, levels) {
  stopifnot(is.integer(x))
  stopifnot(is.character(levels))

  structure(
    x,
    levels = levels,
    class = "factor"
  )
}
