library(tidyverse)
library(shiny)

# library(railtrails)
# library(modelr)
# library(lme4)
# d <- railtrails
# d <- unnest(d, raw_reviews)
# m1 <- lmer(raw_reviews ~ 1 + (1|name) + (1|state), data = d)
# state_ranefs <- ranef(m1) %>%
#     pluck(2) %>%
#     rownames_to_column("state") %>%
#     rename(state_pred = '(Intercept)')
# trail_ranefs <- ranef(m1) %>%
#     pluck(1) %>%
#     rownames_to_column("name") %>%
#     rename(trail_pred = '(Intercept)')
# d <- left_join(d, trail_ranefs)
# d <- left_join(d, state_ranefs)
# d <- mutate(d, pred_review = fixef(m1)[1] + trail_pred + state_pred)
# d <- mutate(d,
#             URL = ifelse(!is.na(lat), str_c("https://www.google.com/maps/search/?api=1&query=", lat, ",", lng), NA))
# dd <- d %>%
#     distinct(name, state, distance, category, surface, n_reviews, mean_raw_review, pred_review, URL)
# write_rds(dd, "app/processed_data.rds")
dd <- readr::read_rds("processed_data.rds")
dd$n_reviews <- as.integer(stringr::str_extract(dd$n_reviews, "\\(?[0-9,.]+\\)?"))

# dd %>%
#     gather(type_of_review, val, -name, -state) %>%
#     ggplot(aes(x = val, fill = type_of_review)) +
#     geom_density(alpha = .3) +
#     theme_bw()

options(DT.options = list(pageLength = 10))

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinythemes::shinytheme("yeti"),
                titlePanel("Find the top rail-trails (using reviews from TrailLink)"),
                p("Choose a state (or click the 'All states' checkbox) to view the top rated rail-trails based on predictions from a multi-level model."),

                # Sidebar with a slider input for number of bins
                sidebarLayout(
                    sidebarPanel(
                        selectInput("state", "State", dd$state %>% unique(), "MI"),
                        checkboxInput("overall", "All states"),
                        p("Rail-trails data and reviews are available from the railtrails R package:", tags$a("https://jrosen48.github.io/railtrails/")),
                          p("The source code for this app is available here:", tags$a("https://github.com/jrosen48/railtrails")),
                          p("If you like using this, please consider visiting or even making a donation to the Rails to Trails Conservancy via", tags$a("https://www.traillink.com/"))
                        ),

                        # Show a plot of the generated distribution
                        mainPanel(
                            dataTableOutput("df")
                        )
                    )

                )

                # Define server logic required to draw a histogram
                server <- function(input, output) {

                    output$df <- renderDataTable({

                        if (input$overall) {

                            dd %>%
                                filter(!is.na(pred_review)) %>%
                                arrange(desc(pred_review)) %>%
                                select(State = state,
                                       `Trail name` = name,
                                       `Length (mi.)` = distance,
                                       `Surface` = surface,
                                       `Number of reviews` = n_reviews,
                                       `Review` = pred_review,
                                       `Trailhead map` = URL) %>%
                                mutate(`Trailhead map` = paste0("<a href='", `Trailhead map` ,"' target='_blank'>", `Trailhead map`,"</a>"),
                                       Review = round(Review, 3))

                        } else {

                            dd %>%
                                filter(state == input$state) %>%
                                filter(!is.na(pred_review)) %>%
                                arrange(desc(pred_review)) %>%
                                select(State = state,
                                       `Trail name` = name,
                                       `Length (mi.)` = distance,
                                       `Surface` = surface,
                                       `Number of reviews` = n_reviews,
                                       `Review` = pred_review,
                                       `Trailhead map` = URL) %>%
                                mutate(`Trailhead map` = paste0("<a href='", `Trailhead map` ,"' target='_blank'>", `Trailhead map`,"</a>"),
                                       Review = round(Review, 3))

                        }
                    }, escape = FALSE)
                }

                # Run the application
                shinyApp(ui = ui, server = server)

