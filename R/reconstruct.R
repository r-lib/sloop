#' Reconstruct an S3 class from a template
#'
#' This is useful in methods that use [NextMethod()] to get the default
#' behaviour, but need to copy over attributes afterwards. Typically,
#' a reconstruct method should use the constructor rather than copying
#' attributes.
#'
#' @section S3 dispatch:
#'
#' This is an S3 generic that (unusually) dispatches on the second argument,
#' `old`.
#'
#' @export
#' @param new Freshly created object (typically a bare vector)
#' @param old Existing object to use an template
reconstruct <- function(new, old) {
  UseMethod("reconstruct", old)
}
