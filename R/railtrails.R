#' Rail-trail trail data
#'
#' Information and reviews for rail-trails in the United States
#'
#' @source https://www.traillink.com/
#' @format Data frame with columns
#' \describe{
#' \item{name}{Name of rail-trail}
#' \item{distance}{distance (miles)}
#' \item{surface}{surface material}
#' \item{category}{trail category}
#' \item{mean_review{mean review rating}
#' \item{description}{text description of trail}
#' \item{n_reviews}{number of reviews}
#' \item{raw_reviews}{list-column with a vector of reviews}
#' }
#' @examples
#' railtrails
#'
#' # to expand vector of review ratings in raw_reviews column:
#' library(tidyr)
#' railtrails <- railtrails %>% unnest(raw_reviews)

"railtrails"
