#' Find S3 method from its name
#'
#' @param name A string or unquoted symbol
#' @return A function, or an error stating why the method could not be
#'   found
#' @export
#' @examples
#' s3_get_method(mean.Date)
#' s3_get_method(weighted.mean.Date)
s3_get_method <- function(name) {
  name <- ensym(name)

  method <- parse_method(as.character(name))
  if (is.null(method)) {
    stop("Could not find generic", call. = FALSE)
  }

  fun <- method_find(method[[1]], method[[2]])[[1]]
  if (is.null(fun)) {
    stop("Could not find method", call. = FALSE)
  }

  fun
}
