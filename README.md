
<!-- README.md is generated from README.Rmd. Please edit that file -->
railtrails
==========

This R data package provides rail information about [rail trails](https://en.wikipedia.org/wiki/Rail_trail) from the excellent [TrailLink](https://www.traillink.com/) website, sponsored by the Rails-to-Trails Conservancy.

Installation
------------

You can install railtrails from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("jrosen48/railtrails")
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

"Unnesting" trail reviews
-------------------------

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

If you like using this package, please consider visiting or even making a donation to the Rails to Trails Conservancy at via <https://www.traillink.com/>.

Future improvements
-------------------

I am interested in adding the trailhead location to the data; this can be done fairly easily using the Google Maps API but will take considerable time due to the number of trails. Contributions are welcome. Requests for features can be made [on GitHub](https://github.com/jrosen48/railtrails/issues).

Acknowledgment
--------------

Thank you to [Bob Rudis](https://rud.is/) for feedback that helped to improve this package.
