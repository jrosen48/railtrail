
<!-- README.md is generated from README.Rmd. Please edit that file -->
railtrails
==========

This R data package provides rail information about [rail trails](https://en.wikipedia.org/wiki/Rail_trail) from the excellent [TrailLink](https://www.traillink.com/) website, sponsored by the Rails-to-Trails Conservancy.

Installation
------------

You can install railtrails from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("jrosen48/railtrail")
```

Loading the data
----------------

Here is how to load the data:

``` r
railtrails <- railtrails::railtrails
railtrails
#> # A tibble: 11,420 x 9
#>    state                                name distance       surface
#>    <chr>                               <chr>    <dbl>         <chr>
#>  1    AK                         Chase Trail     14.0  Dirt, Gravel
#>  2    AK          Tony Knowles Coastal Trail     11.0       Asphalt
#>  3    AK                Bird to Gird Pathway     13.0       Asphalt
#>  4    AK            Campbell Creek Greenbelt      7.5 Asphalt, Dirt
#>  5    AK                         Chase Trail     14.0  Dirt, Gravel
#>  6    AK              Goose Lake Park Trails      1.5 Asphalt, Dirt
#>  7    AK                    Homer Spit Trail      4.0       Asphalt
#>  8    AK Lanie Fleischer Chester Creek Trail      3.9 Asphalt, Dirt
#>  9    AK   Palmer-Moose Creek Railroad Trail      6.1        Gravel
#> 10    AK                    Ship Creek Trail      2.6       Asphalt
#> # ... with 11,410 more rows, and 5 more variables: category <chr>,
#> #   mean_review <int>, description <chr>, n_reviews <chr>,
#> #   raw_reviews <list>
```

"Unnesting"" trail reviews
--------------------------

You may want to "unnest" the list-column with reviews in the following way:

``` r
library(tidyr)
railtrails <- railtrails::railtrails
railtrails <- railtrails %>% unnest(raw_reviews)
railtrails
#> # A tibble: 73,059 x 9
#>    state                       name distance       surface        category
#>    <chr>                      <chr>    <dbl>         <chr>           <chr>
#>  1    AK                Chase Trail     14.0  Dirt, Gravel      Rail-Trail
#>  2    AK Tony Knowles Coastal Trail     11.0       Asphalt      Rail-Trail
#>  3    AK Tony Knowles Coastal Trail     11.0       Asphalt      Rail-Trail
#>  4    AK Tony Knowles Coastal Trail     11.0       Asphalt      Rail-Trail
#>  5    AK Tony Knowles Coastal Trail     11.0       Asphalt      Rail-Trail
#>  6    AK       Bird to Gird Pathway     13.0       Asphalt      Rail-Trail
#>  7    AK       Bird to Gird Pathway     13.0       Asphalt      Rail-Trail
#>  8    AK       Bird to Gird Pathway     13.0       Asphalt      Rail-Trail
#>  9    AK   Campbell Creek Greenbelt      7.5 Asphalt, Dirt Greenway/Non-RT
#> 10    AK   Campbell Creek Greenbelt      7.5 Asphalt, Dirt Greenway/Non-RT
#> # ... with 73,049 more rows, and 4 more variables: mean_review <int>,
#> #   description <chr>, n_reviews <chr>, raw_reviews <int>
```

Note
----

I checked whether they had a way to access the reviews on the site through an API. They didn't, so I checked their `robots.txt` file at `http://traillink.com/robots.txt`. They didn't disallow access to their trail pages or the pages listing trails for each state. Additionally, I checked their terms of service, which did not prohibit accessing their data in this way, and so I proceeded to scrape this data using a reasonable delay in between page requests in order to not over-burden their server.
