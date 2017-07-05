#' List methods for a generic (or class)
#'
#' Returns information about all methods belong to a generic or a class.
#' In S3, methods belong to a generic, but it is often useful to see what
#' generics have been provided methods for a given class. These are
#' wrappers around [utils::methods()], which returns a lot of useful information
#' in an attribute.
#'
#' @param x Name of class or generic
#' @return A tibble with columns `generic`, `visible`, `class`, `visible`,
#'   and `isS4`.
#' @export
#' @examples
#' s3_methods_class("Date")
#' s3_methods_generic("anova")
s3_methods_class <- function(x) {
  info <- attr(utils::methods(class = x), "info")
  info <- tibble::as_tibble(info)
  info <- tibble::rownames_to_column(info, "method")

  info$class <- x
  info$from <- as.character(info$from)

  info[c("generic", "class", "visible", "from", "isS4")]
}

#' @export
#' @rdname s3_methods_class
s3_methods_generic <- function(x) {
  info <- attr(utils::methods(x), "info")
  info <- tibble::as_tibble(info)
  info <- tibble::rownames_to_column(info, "method")

  generic_esc <- gsub("\\.", "\\\\.", x)
  info$class <- gsub(paste0("^", generic_esc, "\\."), "", info$method)
  info$from <- gsub(paste0(" for ", generic_esc), "", info$from)

  info[c("generic", "class", "visible", "from", "isS4")]
}

