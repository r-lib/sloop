#' POSIXct
#'
#' A `POSIXct` is a double vector. Its value represents the number of
#' seconds since the Unix "Epoch", 1970-01-01. It has one attribute:
#' the timezone.
#'
#' @param x A double vector
#' @param tzone The time zone, a character vector of length one.
#'   `""` is a dummy value that means to use the local time zone.
#'   [OlsonNames()] lists all other valid names
#' @export
#' @examples
#' new_POSIXct(as.double(1:10))
new_POSIXct <- function(x, tzone = "") {
  stopifnot(is.character(tzone), length(tzone) == 1)

  new_s3_dbl(x, tzone = tzone, class = c("POSIXct", "POSIXt"))
}
