#' Date
#'
#' A `Date` is a double vector. The value represent the number of days
#' since the Unix "epoch", 1970-01-01. It has no attributes.
#'
#' @note
#' The `Date()` helper is rather inefficient as it uses [ISOdate()]
#' which works by pasting together a string and then passing to [strptime()].
#' A more efficient implementation is available [lubridate::make_date()]
#'
#' @param year,month,day Numeric vectors defining the date.
#' @return A S3 object with class Date
#' @export
#' @examples
#' new_Date(as.double(1:10))
Date <- function(year, month, day) {
  as.Date(ISOdate(year, month, day, tz = "UTC"), tz = "UTC")
}

#' @export
#' @rdname Date
#' @param x A numeric vector
new_Date <- function(x) {
  new_s3_dbl(x, class = "Date")
}
