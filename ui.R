library(shiny)

range.year <- range(1974, 2011)

ui <- fluidPage(
  
  titlePanel("Exploring Meteorite Data"),
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Q2"),
              tabPanel("Q3"),
              tabPanel("Resources for Observing Meteorites", 
                       p(strong("Question 4")), textOutput("q4"),
                       p(strong("Table")), textOutput("table.description"),
                       sidebarPanel(sliderInput("year.choice", label = "Years",
                                                min = range.year[1], 
                                                max = range.year[2], 
                                                value = range.year)),
                       tableOutput("q4.table"), p(strong("Linear Regression")), 
                       textOutput("fit.intro"), plotOutput("q4.plot"),
                       textOutput("fit.description"), plotOutput("new.plot"),
                       textOutput("new.description"), p(strong("Conclusion")),
                       textOutput("conclusion"), p(strong("Implications")),
                       textOutput("implications"))
  )
  
)