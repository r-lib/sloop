
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sloop

[![CRAN
status](https://www.r-pkg.org/badges/version/sloop)](https://cran.r-project.org/package=sloop)
[![Travis build
status](https://travis-ci.org/r-lib/sloop.svg?branch=master)](https://travis-ci.org/r-lib/sloop)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/sloop/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/sloop?branch=master)

The goal of sloop is to provide tools to help interactive explore and
understand object oriented programming in R. For help creating new
classes of S3 vector, see the [vctrs](https://vctrs.r-lib.org) package.

## Installation

You can install sloop from github with:

``` r
# install.packages("devtools")
devtools::install_github("r-lib/sloop")
```

## Usage

``` r
library(sloop)
```

sloop provides a variety of tools for understanding how S3 works. The
most useful is probably `s3_dispatch()`. Given a function call, it shows
the set of methods that are considered, found, and actually called:

``` r
s3_dispatch(print(Sys.time()))
#> => print.POSIXct
#>    print.POSIXt
#>  * print.default
```

To the best of my ability it covers all the details of S3 including
group generics, internal generics, implicit classes, and use of
`NextMethod()`:

``` r
# Implicit class
x <- matrix(1:6, nrow = 2)
s3_dispatch(print(x))
#>    print.matrix
#>    print.integer
#>    print.numeric
#> => print.default

# Internal generic 
s3_dispatch(length(x))
#> => length (internal)

# NextMethod
s3_dispatch(Sys.Date()[1])
#> => [.Date
#>    [.default
#> -> [ (internal)

# group generic
s3_dispatch(sum(Sys.Date()))
#>    sum.Date
#>    sum.default
#> => Summary.Date
#>    Summary.default
#> -> sum (internal)
```
