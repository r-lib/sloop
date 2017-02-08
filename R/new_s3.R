#' S3 vector constructors
#'
#' These functions aid in constructing common types of S3 classes.
#' Since S3 does not provide a formal notion of a class, you should always
#' provide a constructor function that wraps one of these functions,
#' checking the type of all attributes.
#'
#' @param x A vector. An error will be throw if the type does not
#'   match the function suffix.
#' @param ... Name-value pairs which form the fields (attributes) of
#'   the class
#' @param class Class vector
#' @name new_s3
#' @examples
#' new_s3_dbl(0, class = "Date")
#' new_s3_dbl(0, class = "POSIXct")
NULL

#' @export
#' @rdname new_s3
new_s3_lgl <- function(x, ..., class) {
  stopifnot(is.logical(x))
  stopifnot(is.character(class))
  structure(x, ..., class = class)
}

#' @export
#' @rdname new_s3
new_s3_int <- function(x, ..., class) {
  stopifnot(is.integer(x))
  stopifnot(is.character(class))
  structure(x, ..., class = class)
}

#' @export
#' @rdname new_s3
new_s3_dbl <- function(x, ..., class) {
  stopifnot(is.double(x))
  stopifnot(is.character(class))
  structure(x, ..., class = class)
}

#' @export
#' @rdname new_s3
new_s3_chr <- function(x, ..., class) {
  stopifnot(is.character(x))
  stopifnot(is.character(class))
  structure(x, ..., class = class)
}

#' @export
#' @rdname new_s3
new_s3_lst <- function(x, ..., class) {
  stopifnot(is.list(x))
  stopifnot(is.character(class))
  structure(x, ..., class = class)
}

#' S3 scalar constructor
#'
#' Used to construct "scalar" S3 objects which use a list with
#' named elements
#'
#' @export
#' @param ... Name-value pairs which form the fields (list-elements) of
#'   the class
#' @inheritParams new_s3
#' @examples
#' new_s3_scalar(a = 1, b = 2, class = "my_class")
new_s3_scalar <- function(..., class) {
  new_s3_lst(list(...), class = class)
}
