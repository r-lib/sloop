#' Date
#'
#' A `Date` is a double vector. The value represent the number of days
#' since the Unix "epoch", 1970-01-01. It has no attributes
#'
#' @param x A numeric vector
#' @return A S3 object with class Date
#' @export
#' @examples
#' new_Date(as.double(1:10))
new_Date <- function(x) {
  new_s3_dbl(x, class = "Date")
}

