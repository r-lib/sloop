#' Determine function type.
#'
#' This function figures out whether the input function is a
#' regular/primitive/internal function, a internal/S3/S4 generic, or a
#' S3/S4/RC method. This is function is slightly simplified as it's possible
#' for a method from one class to be a generic for another class, but that
#' seems like such a bad idea that hopefully no one has done it.
#'
#' @param f unquoted function name
#' @return a character of vector of length 1 or 2.
#' @family object inspection
#' @importFrom methods is
#' @export
#' @examples
#' ftype(`%in%`)
#' ftype(sum)
#' ftype(t.data.frame)
#' ftype(t.test) # Tricky!
#' ftype(writeLines)
#' ftype(unlist)
ftype <- function(f) {
  fexpr <- enexpr(f)
  env <- caller_env()

  if (!is.function(f) && !is.function(f))
    stop("`f` is not a function", call. = FALSE)

  if (is.primitive(f)) {
    c("primitive", if (is_internal_generic(primitive_name(f))) "generic")
  } else if (is_internal(f)) {
    c("internal", if (is_internal_generic(internal_name(f))) "generic")
  } else if (is(f, "standardGeneric")) {
    c("S4", "generic")
  } else if (is(f, "MethodDefinition")) {
    c("S4", "method")
  } else if (is(f, "refMethodDef")) {
    c("RC", "method")
  } else {
    if (!is_symbol(fexpr)) {
      warning("Determination of S3 status requires function name", call. = FALSE)
      gen <- FALSE
      mth <- FALSE
    } else {
      fname <- as.character(fexpr)
      gen <- is_s3_generic(fname, env)
      mth <- is_s3_method(fname, env)
    }

    if (!gen & !mth) {
      "function"
    } else {
      c("S3", if (gen) "generic", if (mth) "method")
    }
  }
}

# Hacky method to get name of primitive function
primitive_name <- function(f) {
  stopifnot(is.primitive(f))

  str <- utils::capture.output(print(f))
  match <- regexec(".Primitive\\([\"](.*?)[\"]\\)", str)
  regmatches(str, match)[[1]][2]
}

is_internal <- function(f) {
  if (!is.function(f) || is.primitive(f))
    return(FALSE)
  calls <- findGlobals(f, merge = FALSE)$functions
  any(calls %in% ".Internal")
}

# fs <- setNames(lapply(ls("package:base"), get), ls("package:base"))
# internal <- Filter(is_internal, fs)
# icall <- sapply(internal, internal_name)
# icall[names(icall) != icall]
internal_name <- function(f) {

  internal_call <- function(x) {
    if (is.name(x) || is.atomic(x)) return(NULL)
    if (identical(x[[1]], quote(.Internal))) return(x)

    # Work backwards since likely to be near end last
    # (and e.g. unlist has multiple .Internal calls)
    for (i in rev(seq_along(x))) {
      icall <- internal_call(x[[i]])
      if (!is.null(icall)) return(icall)
    }
    NULL
  }
  call <- internal_call(body(f))
  as.character(call[[2]][[1]])
}
