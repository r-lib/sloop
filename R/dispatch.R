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
s3_dispatch <- function(call, env = parent.frame()) {
  call <- substitute(call)

  generic <- as.character(call[[1]])
  x <- eval(call[[2]], env)

  class <- if (is.object(x)) class(x) else implicit_class(x)
  methods <-paste0(generic, ".", c(class, "default"))

  exists <- vapply(methods, exists, logical(1), envir = env)
  cat(paste0(ifelse(exists, "*", " "), " ", methods,
    collapse = "\n"), "\n", sep = "")
}
