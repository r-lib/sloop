#' data.frame
#'
#' A `data.frame` is a list with "row.names" attribute. Each element of the
#' list must be named, and of the same length.
#'
#' @param x A list.
#' @param row.names Can be a integer or character vector the same length as
#'   the data frame. Alternatively can be a numeric vector of length 2,
#'   as created by [.set_row_names()].
#' @export
new_data.frame <- function(x, row.names = NULL) {
  stopifnot(is.list(x))

  n <- if (length(x) == 0) 0 else length(x[[1]])
  lengths <- vapply(x, length, integer(1))
  stopifnot(all(lengths == n))

  if (is.null(row.names)) {
    row.names <- .set_row_names(n)
  } else {
    stopifnot(is.character(row.names) || is.numeric(row.names))
    stopifnot(length(row.names) == n || length(row.names) == 2)
  }

  structure(
    x,
    class = "data.frame",
    row.names = row.names
  )
}
