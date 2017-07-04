#' Check that `...` passed to a method is empty
#'
#' It's good practice to use `...` in S3 generic so that the methods can
#' take additional arguments. However, since `...` silently swallow mis-nammed
#' arguments, it's friendly to tell the user when there's something in `...`
#' that you didn't expect
#'
#' @param ... `...` passed on in an S3 method.
#' @export
#' @examples
#' foo <- function(x, ...) UseMethod("foo")
#'
#' foo.character <- function(x, ..., truncate = 10) {
#'   substr(x, 1, truncate)
#' }
#' # Silently returns wrong result because misspelled argument name is
#' # swallowed by ...
#' foo("text", trncate = 5)
#'
#' foo.character <- function(x, ..., truncate = 10) {
#'   check_method_dots(...)
#'   substr(x, 1, truncate)
#' }
#' # Throws an error because `...` is not empty
#' \dontrun{
#' foo("text", trncate = 5)
#' }
check_method_dots <- function(...) {
  args <- names(exprs(..., .ignore_empty = "all"))
  if (length(args) == 0) {
    return()
  }

  named <- encodeString(args[args != ""], quote = "`")
  n_unnamed <- sum(args == "")

  if (n_unnamed > 0) {
    named <- c(named, paste0(n_unnamed, " unnamed"))
  }

  abort(paste0(
    "S3 method called with unknown arguments ",
    "(", paste0(named, collapse = ", "), ")"
  ))
}
