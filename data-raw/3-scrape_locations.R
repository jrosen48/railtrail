library(railtrails)
library(googleway)


key <- ""

load("data/railtrails.rda")

d <- railtrails

d$lng <- NA
d$lat <- NA

GoogleGeocodeCoordinates <- function(location_query, key) {
    # Gets location coordinates from Google geolocation API.
    #
    # Args:
    #   location_query: Character string for query parameter in API request.
    #   key: Google Geolocation API key character string.  Should not be hard 
    #       coded!
    #
    # Returns:
    #   Double vector, length 2.  Position 1 is latitude, position 2 is 
    #       longitude.
    
    out <- tryCatch( {
        message(paste('querying: ', location_query, ' ...'))

        res <- google_geocode(address = location_query, key = key)
        message(paste('response status: ', res$status))
        
        out <- c(res$results$geometry$location$lat[1], 
                 res$results$geometry$location$lng[1])
    },
    error=function(cond) {
        message('try catch error')
        return(NA)
    },
    warning=function(cond) {
        message('try catch warning')
        return(NA)
        }
    )
    
    return(out)
}

for(i in 1:nrow(d)){
    # Combining the state and trail name. 
    completeName <- paste0(toupper(d$state[i]), " - ", d$name[i]) 
    
    res <- GoogleGeocodeCoordinates(completeName, key = key)
    
    if (is.null(res)) {
        message("Z, trying without state acronym")
        noStateName <- stringr::str_sub(completeName, 6)
        res <- GoogleGeocodeCoordinates(noStateName, key = key)
        d$lat[i] <- NA
        d$lng[i] <- NA
    } else {
        d$lat[i] <- res[1]
        d$lng[i] <- res[2]
    }
    
    # Logging and progress update
    message(paste0("Processed (", i, "/", nrow(d)
                   , ")\nlat: ", res[1], "\nlon: ", res[2], "\n"))
    
}

railtrails <- d %>% dplyr::select(state:raw_reviews, lat, lng)

devtools::use_data(railtrails, overwrite = T)
