
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sloop

[![CRAN
status](https://www.r-pkg.org/badges/version/sloop)](https://cran.r-project.org/package=sloop)
[![Travis build
status](https://travis-ci.org/r-lib/sloop.svg?branch=master)](https://travis-ci.org/r-lib/sloop)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/sloop/branch/master/graph/badge.svg)](https://codecov.io/github/r-lib/sloop?branch=master)

The goal of sloop is to provide tools to help you interactively explore
and understand object oriented programming in R, particularly with S3.

Please note that unlike other [r-lib](https://github.com/r-lib)
packages, sloop only works with R 3.3 and later.

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

To the best of my ability it covers all the details of S3 method
dispatch including group generics, internal generics, implicit classes,
and use of `NextMethod()` (indicated by `->`):

``` r
# Implicit class
x <- matrix(1:6, nrow = 2)
s3_dispatch(print(x))
#>    print.matrix
#>    print.integer
#>    print.numeric
#> => print.default

# Internal generic 
length.numeric <- function(x) 10
s3_dispatch(length(x))
#>    length.matrix
#>    length.integer
#>  * length.numeric
#>    length.default
#> => length (internal)

s3_dispatch(length(structure(x, class = "numeric")))
#> => length.numeric
#>    length.default
#>  * length (internal)

# NextMethod
s3_dispatch(Sys.Date()[1])
#> => [.Date
#>    [.default
#> -> [ (internal)

# group generic + NextMethod()
s3_dispatch(sum(Sys.Date()))
#>    sum.Date
#>    sum.default
#> => Summary.Date
#>    Summary.default
#> -> sum (internal)
```

It also provides tools for determing what type of function or object
you’re dealing with:

``` r
ftype(t)
#> [1] "S3"      "generic"
ftype(t.test)
#> [1] "S3"      "generic"
ftype(t.data.frame)
#> [1] "S3"     "method"

otype(1:10)
#> [1] "base"
otype(mtcars)
#> [1] "S3"
otype(R6::R6Class()$new())
#> [1] "R6"
```

And for retrieving the methods associated with a generic or class:

``` r
s3_methods_class("factor")
#> # A tibble: 27 x 4
#>    generic       class  visible source
#>    <chr>         <chr>  <lgl>   <chr> 
#>  1 [             factor TRUE    base  
#>  2 [[            factor TRUE    base  
#>  3 [[<-          factor TRUE    base  
#>  4 [<-           factor TRUE    base  
#>  5 all.equal     factor TRUE    base  
#>  6 as.character  factor TRUE    base  
#>  7 as.data.frame factor TRUE    base  
#>  8 as.Date       factor TRUE    base  
#>  9 as.list       factor TRUE    base  
#> 10 as.logical    factor TRUE    base  
#> # … with 17 more rows

s3_methods_generic("summary")
#> # A tibble: 36 x 4
#>    generic class                 visible source             
#>    <chr>   <chr>                 <lgl>   <chr>              
#>  1 summary aov                   TRUE    stats              
#>  2 summary aovlist               FALSE   registered S3method
#>  3 summary aspell                FALSE   registered S3method
#>  4 summary check_packages_in_dir FALSE   registered S3method
#>  5 summary connection            TRUE    base               
#>  6 summary data.frame            TRUE    base               
#>  7 summary Date                  TRUE    base               
#>  8 summary default               TRUE    base               
#>  9 summary ecdf                  FALSE   registered S3method
#> 10 summary factor                TRUE    base               
#> # … with 26 more rows
```
