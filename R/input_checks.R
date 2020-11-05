check_single_numeric <- function(x, argument_name){
  if(!is.numeric(x) || length(x) != 1) {
    stop("'", argument_name, "' needs to be a numeric vector of length 1.")
  }
}
