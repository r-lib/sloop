#' Factor
#'
#' A `factor` is an integer with attribute levels. There should be one
#' level for each integer between 1 and `max(x)`. Note that `new_factor()` only
#' checks types; it does not assert that the values are a valid factor.
#' An `ordered` factor has the same properties as a factor, but possesses
#' an extra class that marks levels as having a total ordering.
#'
#' @param x An integer vector
#' @param levels A character vector of levels
#' @param new,old Arguments for reconstruction
#' @export
new_factor <- function(x, levels) {
  stopifnot(is.integer(x))
  stopifnot(is.character(levels))

  structure(
    x,
    levels = levels,
    class = "factor"
  )
}

#' @export
#' @rdname new_factor
new_ordered <- function(x, levels) {
  stopifnot(is.integer(x))
  stopifnot(is.character(levels))

  structure(
    x,
    levels = levels,
    class = c("ordered", "factor")
  )
}

#' @export
#' @rdname new_factor
reconstruct.factor <- function(new, old) {
  new_factor(new, levels = attr(old, "levels"))
}

#' @export
#' @rdname new_factor
reconstruct.ordered <- function(new, old) {
  new_ordered(new, levels = attr(old, "levels"))
}
