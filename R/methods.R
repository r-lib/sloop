#' List methods for a S3 or S4 generic (or class)
#'
#' Returns information about all methods belong to a generic or a class.
#' In S3 and S4, methods belong to a generic, but it is often useful to see what
#' generics have been provided methods for a given class. These are
#' wrappers around [utils::methods()], which returns a lot of useful information
#' in an attribute.
#'
#' @param x Name of class or generic
#' @return A tibble with columns `generic`, `visible`, `class`, `visible`,
#'   and `source`.
#' @export
#' @examples
#' s3_methods_class("Date")
#' s3_methods_generic("anova")
#'
#' s4_methods_class("Date")
#' s4_methods_generic("anova")
s3_methods_class <- function(x) {
  methods <- methods_class(x)
  methods <- methods[!methods$isS4, ]
  methods$isS4 <- NULL

  methods
}

#' @export
#' @rdname s3_methods_class
s3_methods_generic <- function(x) {
  methods <- methods_generic(x)
  methods <- methods[!methods$isS4, ]
  methods$isS4 <- NULL

  methods
}


#' @export
#' @rdname s3_methods_class
s4_methods_class <- function(x) {
  methods <- methods_class(x)
  methods <- methods[methods$isS4, ]
  methods$isS4 <- NULL

  methods
}

#' @export
#' @rdname s3_methods_class
s4_methods_generic <- function(x) {
  methods <- methods_generic(x)
  methods <- methods[methods$isS4, ]
  methods$isS4 <- NULL

  methods
}

methods_class <- function(x) {
  info <- attr(utils::methods(class = x), "info")
  info <- tibble::as_tibble(info)
  info <- tibble::rownames_to_column(info, "method")

  info$class <- x
  info$source <- as.character(info$from)

  info[c("generic", "class", "visible", "source", "isS4")]
}

methods_generic <- function(x) {
  info <- attr(utils::methods(x), "info")
  info <- tibble::as_tibble(info)
  info <- tibble::rownames_to_column(info, "method")

  generic_esc <- gsub("([.\\[])", "\\\\\\1", x)
  info$class <- gsub(paste0("^", generic_esc, "[.,]"), "", info$method)
  info$class <- gsub("-method$", "", info$class)
  info$source <- gsub(paste0(" for ", generic_esc), "", info$from)

  info[c("generic", "class", "visible", "source", "isS4")]
}
