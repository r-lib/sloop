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
#' x2 <- structure(2, class = "numeric")
#'
#' my_length <- function(x) UseMethod("my_length")
#' s3_dispatch(my_length(x1))
#' s3_dispatch(my_length(x2))
#'
#' s3_dispatch(length(x1))
#' s3_dispatch(length(x2))
s3_dispatch <- function(call, env = parent.frame()) {
  call <- substitute(call)
  generic <- as.character(call[[1]])
  x <- eval(call[[2]], env)

  class <- s3_class(x)
  methods <- paste0(generic, ".", c(class, "default"))

  # Add group generic if necssary
  group <- find_group(generic)
  if (!is.null(group)) {
    group_methods <- paste0(group, ".", class)
    methods <- c(methods, group_methods)
  }

  # internal generics will always resolve to something
  # currently showing with generic name
  if (is_internal_generic(generic)) {
    if (is.object(x)) {
      methods <- c(methods, generic)
    } else {
      methods <- generic
    }
  }

  # rely on method() to look for methods in the right places
  exists <- methods %in% methods(generic)

  new_s3_scalar(
    method = methods,
    exists = exists,
    class = "method_table"
  )
}

#' @export
print.method_table <- function(x, ...) {
  bullets <- paste0(ifelse(x$exists, "*", " "), " ", x$method, "\n", collapse = "")
  cat(bullets, sep = "")

  invisible(x)
}

find_group <- function(generic) {
  g <- group_generics()
  g_table <- stats::setNames(rep(names(g), lengths(g)), unlist(g))

  if (!generic %in% names(g_table))
    return()

  g_table[[generic]]
}
