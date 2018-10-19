#' Illustrate S3 dispatch
#'
#' @param call Example call to S3 method
#' @param env Environment in which to evaluate call
#' @export
#' @examples
#' x <- Sys.time()
#' s3_dispatch(print(x))
#' s3_dispatch(is.numeric(x))
#' s3_dispatch(as.Date(x))
#' s3_dispatch(sum(x))
#'
#' # Internal vs. regular generic
#' x1 <- 1
#' x2 <- structure(2, class = "double")
#'
#' my_length <- function(x) UseMethod("my_length")
#' s3_dispatch(my_length(x1))
#' s3_dispatch(my_length(x2))
#'
#' length.double <- function(x) 10
#' s3_dispatch(length(x1))
#' s3_dispatch(length(x2))
s3_dispatch <- function(call, env = parent.frame()) {
  call <- enexpr(call)
  if (!is_call(call)) {
    stop("`call` must be a function call", call. = FALSE)
  }
  generic <- as.character(call[[1]])
  x <- eval(call[[2]], env)

  class <- c(s3_class(x), "default")
  names <- paste0(generic, ".", class)
  impls <- method_find(generic, class, env = env)

  # Add group generic if necssary
  group <- find_group(generic)
  if (!is.null(group)) {
    names <- c(names, paste0(group, ".", class))
    impls <- c(impls, method_find(group, class, env = env))
  }

  # internal generics can resolve to internal method
  if (is_internal_generic(generic)) {
    internal <- !is.object(x)
    names <- c(names, paste0(generic, " (internal)"))
    impls <- c(impls, get(generic))
  } else {
    internal <- FALSE
  }

  structure(
    list(
      method = names,
      impl = impls,
      exists = !purrr::map_lgl(impls, is.null),
      to_next = purrr::map_lgl(impls, calls_next_method)
    ),
    internal = internal,
    class = "method_table"
  )
}

calls_next_method <- function(f) {
  if (is.primitive(f) || is.null(f)) {
    FALSE
  } else {
    uses <- codetools::findGlobals(f, merge = FALSE)$functions
    any(uses == "NextMethod")
  }

}

method_find <- function(generic, class, env = parent.frame()) {
  purrr::map2(generic, class, utils::getS3method, envir = env, optional = TRUE)
}

#' @export
print.method_table <- function(x, ...) {


  if (attr(x, "internal")) {
    bullet <- ifelse(x$exists, " *", "  ")
    bullet[[length(bullet)]] <- "=>"
  } else {
    first <- TRUE
    to_next <- TRUE

    bullet <- character(length(x$exists))
    for (i in seq_along(x$exists)) {
      if (!x$exists[[i]]) {
        bullet[[i]] <- "  "
      } else {
        if (first) {
          bullet[[i]] <- "=>"
          first <- FALSE
        } else if (to_next) {
          bullet[[i]] <- "->"
        } else {
          bullet[[i]] <- " *"
        }
        to_next <- (to_next || first) && x$to_next[[i]]
      }
    }
  }

  method <- ifelse(x$exists, x$method, crayon::silver(x$method))

  cat(paste0(bullet, " ", method, "\n", collapse = ""), sep = "")
  invisible(x)
}

find_group <- function(generic) {
  g <- group_generics()
  g_table <- stats::setNames(rep(names(g), lengths(g)), unlist(g))

  if (!generic %in% names(g_table))
    return()

  g_table[[generic]]
}
