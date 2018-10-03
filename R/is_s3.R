#' Determine if a function is an S3 generic or S3 method.
#'
#' `is_s3_generic()` compares name checks for both internal and regular
#' generics. `is_s3_method()` builds names of all possible generics for that
#' function and then checks if any of them actually is a generic.
#'
#' @param fname Name of function as a string. Need name of function because
#'   it's impossible to determine whether or not a function is a S3 method
#'   based only on its contents.
#' @param env Environment to search in.
#' @export
#' @examples
#' is_s3_generic("mean")
#' is_s3_generic("sum")
#' is_s3_generic("[[")
#' is_s3_generic("unlist")
#' is_s3_generic("runif")
#'
#' is_s3_method("t.data.frame")
#' is_s3_method("t.test") # Just tricking!
#' is_s3_method("as.data.frame")
#' is_s3_method("mean.Date")
is_s3_generic <- function(fname, env = parent.frame()) {
  stopifnot(is.character(fname), length(fname) == 1)

  f <- get(fname, env, mode = "function")

  if (is.primitive(f) || is_internal(f)) {
    is_internal_generic(fname)
  } else {
    uses <- codetools::findGlobals(f, merge = FALSE)$functions
    any(uses == "UseMethod")
  }
}

#' @rdname is_s3_generic
#' @export
is_s3_method <- function(fname, env = parent.frame()) {
  stopifnot(is.character(fname), length(fname) == 1)
  !is.null(parse_method(fname, env))
}

stop_list <- function() {
  if (getRversion() < "3.3.0") {
    getNamespace("tools")[[".make_S3_methods_stop_list"]](NULL)
  } else {
    tools::nonS3methods(NULL)
  }
}

# Returns character vector of length 2, or
parse_method <- function(name, env = parent.frame()) {
  if (name %in% stop_list()) return(NULL)

  pieces <- strsplit(name, ".", fixed = TRUE)[[1]]
  n <- length(pieces)

  # No . in name, so can't be method
  if (n == 1) return(NULL)

  for (i in seq_len(n - 1)) {
    generic <- paste0(pieces[seq_len(i)], collapse = ".")
    class <- paste0(pieces[(i + 1):n], collapse = ".")

    if (exists(generic, env) && is_s3_generic(generic, env))
      return(c(generic, class))
  }
  NULL
}

is_internal <- function(f) {
  calls <- codetools::findGlobals(f, merge = FALSE)$functions
  any(calls %in% ".Internal")
}

is_internal_generic <- function(x) {
  x %in% internal_generics()
}

group_generics <- function() {
  # S3 group generics can be defined by combining S4 group generics
  groups <- list(
    Ops = c("Arith", "Compare", "Logic"),
    Math = c("Math", "Math2"),
    Summary = "Summary",
    Complex = "Complex"
  )

  lapply(groups, function(x) unlist(lapply(x, methods::getGroupMembers)))
}

internal_generics <- function() {
  group <- unlist(group_generics(), use.names = FALSE)
  primitive <- .S3PrimitiveGenerics

  # Extracted from ?"internal generic"
  internal <- c("[", "[[", "$", "[<-", "[[<-", "$<-", "unlist",
    "cbind", "rbind", "as.vector")

  c(group, primitive, internal)
}
