#' POSIXct
#'
#' A `POSIXct` is a double vector. Its value represents the number of
#' seconds since the Unix "Epoch", 1970-01-01. It has one attribute:
#' the timezone.
#'
#' @note
#' The `POSIXct()` help is rather inefficient as it uses [ISOdatetime()]
#' which works by pasting together a string and then passing to [strptime()].
#' A more efficient implementation is available [lubridate::make_datetime()]
#'
#' @param x A double vector
#' @param year,month,day Numeric vectors defining the date.
#' @param hour,minute,sec Numeric vectors defining the time.
#' @param tzone The time zone, a character vector of length one.
#'   `""` is a dummy value that means to use the local time zone.
#'   [OlsonNames()] lists all other valid names
#' @export
#' @examples
#' new_POSIXct(as.double(1:10))
POSIXct <- function(year, month, day, hour, minute, sec, tzone = "") {
  ISOdatetime(year, month, day, hour, minute, sec, tz = tzone)
}

#' @export
#' @rdname POSIXct
new_POSIXct <- function(x, tzone = "") {
  stopifnot(is.character(tzone), length(tzone) == 1)

  new_s3_dbl(x, tzone = tzone, class = c("POSIXct", "POSIXt"))
}
