library(shiny)
library(dplyr)

d <- railtrails::railtrails

d <- tidyr::unnest(d, raw_reviews)

m1 <- lme4::lmer(raw_reviews ~ 1 + (1|name) + (1|state), data = d)

state_ranefs <- lme4::ranef(m1) %>%
    purrr::pluck(2) %>%
    tibble::rownames_to_column("state") %>%
    dplyr::rename(state_pred = '(Intercept)')

trail_ranefs <- lme4::ranef(m1) %>%
    purrr:::pluck(1) %>%
    tibble::rownames_to_column("name") %>%
    dplyr::rename(trail_pred = '(Intercept)')

d <- dplyr::left_join(d, trail_ranefs)
d <- dplyr::left_join(d, state_ranefs)

d <- dplyr::mutate(d, pred_review = lme4::fixef(m1)[1] + trail_pred + state_pred)

mean_raw_review_df <- d %>%
    group_by(name) %>%
    filter(!is.na(raw_reviews)) %>%
    summarize(mean_raw_review = mean(raw_reviews))

dd <- d %>%
    distinct(name, state, distance, category, surface, n_reviews, mean_raw_review, pred_review, lat, lng) %>%
    left_join(mean_raw_review_df) %>%
    mutate(URL = stringr::str_c("https://www.google.com/maps/search/?api=1&query=", lat, ",", lng))

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinythemes::shinytheme("cerulean"),
                h1("Find the best rail-trails using Trail Link reviews"),

                p("Choose a state to view the top rail-trails based on reviews from the Trail Link website!"),

                selectInput("state", "Select state", dd$state %>% unique(), "MI"),

                dataTableOutput("df"),

                p("Notes:"),
                tags$li("The predicted review is from a model-based prediction that takes account of how many reviews there are (and how different they are), whereas raw review is the arithmetic mean of the reviews, even if there are only one or two available for the trail."),
                tags$li("The source code for this app is available here: https://jrosen48.github.io/railtrails/"),
                tags$li("Rail-trails data and reviews are available from the railtrails R package: https://jrosen48.github.io/railtrails/"),
                tags$li("If you like using this, please consider visiting or even making a donation to the Rails to Trails Conservancy at via https://www.traillink.com/")

                # # Sidebar with a slider input for number of bins
                # sidebarLayout(
                #     sidebarPanel(
                #         selectInput("state", "State", dd$state %>% unique(), "MI")
                #     ),
                #
                #     # Show a plot of the generated distribution
                #     mainPanel(
                #
                #     )
                #
                # )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$df <- renderDataTable({
        dd %>%
            filter(state == input$state) %>%
            filter(!is.na(pred_review)) %>%
            arrange(desc(pred_review)) %>%
            mutate(pred_review = round(pred_review, 3),
                   mean_raw_review = round(mean_raw_review, 3),
                   n_reviews = as.integer(stringr::str_sub(n_reviews, end = -8))) %>%
            select(State = state,
                   `Trail name` = name,
                   `Distance (mi.)` = distance,
                   `Surface` = surface,
                   `Number of reviews` = n_reviews,
                   `Predicted review` = pred_review,
                   `Raw review` = mean_raw_review,
                   Trailhead = URL)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
