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
# dd %>%
#     gather(type_of_review, val, -name, -state) %>%
#     ggplot(aes(x = val, fill = type_of_review)) +
#     geom_density(alpha = .3) +
#     theme_bw()

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinythemes::shinytheme("cerulean"),
                titlePanel("Find the best rail-trails using Trail Link reviews"),
                p("Choose a state to view the top rail-trails based on reviews from the Trail Link website"),
                p("If you like using this, please consider visiting or even making a donation to the Rails to Trails Conservancy at via https://www.traillink.com/"),

                # Sidebar with a slider input for number of bins
                sidebarLayout(
                    sidebarPanel(
                        selectInput("state", "State", dd$state %>% unique(), "MI"),
                        p("Rail-trails data and reviews are available from the railtrails R package: https://jrosen48.github.io/railtrails/"),
                        p("The source code for this app is available here: https://jrosen48.github.io/railtrails/")
                    ),

                    # Show a plot of the generated distribution
                    mainPanel(
                        dataTableOutput("df")
                    ),
                ),
                p("Note: The review is calculated from a mixed effects, or multi-level, model, that considers how many reviews there are (and how different they are), whereas raw review is the arithmetic mean of the reviews, even if there are only one or two available for the trail.")

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$df <- renderDataTable({
        dd %>%
            filter(state == input$state) %>%
            filter(!is.na(pred_review)) %>%
            arrange(desc(pred_review)) %>%
            select(State = state,
                   `Trail name` = name,
                   `Distance (mi.)` = distance,
                   `Surface` = surface,
                   `Number of reviews` = n_reviews,
                   `Review` = pred_review,
                   `Map` = URL) %>%
            mutate(Review = round(Review, 3))
    })
}

# Run the application
shinyApp(ui = ui, server = server)

