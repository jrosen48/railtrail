
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/jrosen48/railtrails.svg?branch=master)](https://travis-ci.org/jrosen48/railtrails)

railtrails
==========

This R data package provides rail information about [rail trails](https://en.wikipedia.org/wiki/Rail_trail) from the excellent [TrailLink](https://www.traillink.com/) website, sponsored by the Rails-to-Trails Conservancy. Includes information (such as name, length, surface, and reviews) 3,846 trails in every state in the United States.

Installation
------------

You can install railtrails with the `install.packages()` function.

``` r
install.packages("railtrails")
```

Loading the data
----------------

Here is how to load the data:

``` r
d <- railtrails::railtrails
d
#> # A tibble: 3,846 x 11
#>    state name  distance surface category mean_review description n_reviews
#>    <chr> <chr>    <dbl> <chr>   <chr>          <int> <chr>       <chr>    
#>  1 AK    Chas…     14   Dirt, … Rail-Tr…           4 "\r\n     … 1 Reviews
#>  2 AK    Tony…     11   Asphalt Rail-Tr…           5 "The Tony … 5 Reviews
#>  3 AK    Bird…     13   Asphalt Rail-Tr…           5 "\r\n     … 3 Reviews
#>  4 AK    Camp…      7.5 Asphal… Greenwa…           5 "\r\n     … 3 Reviews
#>  5 AK    Goos…      1.5 Asphal… Greenwa…           0 "\r\n     … 0 Reviews
#>  6 AK    Home…      4   Asphalt Greenwa…           5 "On the so… 1 Reviews
#>  7 AK    Lani…      3.9 Asphal… Greenwa…           3 "The Lanie… 1 Reviews
#>  8 AK    Palm…      6.1 Gravel  Rail-Tr…           0 "As its na… 0 Reviews
#>  9 AK    Ship…      2.6 Asphalt Rail-Tr…           4 " \r\nShip… 1 Reviews
#> 10 AL    Chie…     33   Asphalt Rail-Tr…           5 "In northe… 77 Revie…
#> # ... with 3,836 more rows, and 3 more variables: raw_reviews <list>,
#> #   lat <dbl>, lng <dbl>
```

"Unnesting" trail reviews
-------------------------

You may want to "unnest" the list-column with reviews in the following way:

``` r
library(tidyr)
d <- railtrails::railtrails
d <- d %>% unnest(raw_reviews)
d
#> # A tibble: 24,413 x 11
#>    state name  distance surface category mean_review description n_reviews
#>    <chr> <chr>    <dbl> <chr>   <chr>          <int> <chr>       <chr>    
#>  1 AK    Chas…     14   Dirt, … Rail-Tr…           4 "\r\n     … 1 Reviews
#>  2 AK    Tony…     11   Asphalt Rail-Tr…           5 "The Tony … 5 Reviews
#>  3 AK    Tony…     11   Asphalt Rail-Tr…           5 "The Tony … 5 Reviews
#>  4 AK    Tony…     11   Asphalt Rail-Tr…           5 "The Tony … 5 Reviews
#>  5 AK    Tony…     11   Asphalt Rail-Tr…           5 "The Tony … 5 Reviews
#>  6 AK    Tony…     11   Asphalt Rail-Tr…           5 "The Tony … 5 Reviews
#>  7 AK    Bird…     13   Asphalt Rail-Tr…           5 "\r\n     … 3 Reviews
#>  8 AK    Bird…     13   Asphalt Rail-Tr…           5 "\r\n     … 3 Reviews
#>  9 AK    Bird…     13   Asphalt Rail-Tr…           5 "\r\n     … 3 Reviews
#> 10 AK    Camp…      7.5 Asphal… Greenwa…           5 "\r\n     … 3 Reviews
#> # ... with 24,403 more rows, and 3 more variables: lat <dbl>, lng <dbl>,
#> #   raw_reviews <int>
```

Shiny App
---------

An interactive web application (Shiny) for finding the top-rated trails in each state is available [here](https://jmichaelrosenberg.shinyapps.io/railtrails/). The source code is in the [app](/app) directory.

Notes
-----

-   See more information about the variables with `?railtrails`

-   If you like using this package, please consider visiting or even making a donation to the Rails to Trails Conservancy at via <https://www.traillink.com/>

-   The data was last updated 2018/2/2

-   Contributions are welcome. Pull requests and requests for features can be made on GitHub

-   Thank you to [Bob Rudis](https://rud.is/) for feedback that helped to improve this package

Code of conduct
---------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
