library(shiny)

range.year <- range(1974, 2011)

ui <- fluidPage(
  
  titlePanel("Exploring Meteorite Data"),
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Q2"),
              tabPanel("Q3"),
              tabPanel("Resources for Observing Meteorites", 
                       p(strong("Question 4")), textOutput("q4"), p(""),
                       p(strong("Table")), textOutput("table.description"), 
                       p(""),
                       sidebarPanel(sliderInput("year.choice", label = "Years",
                                                min = range.year[1], 
                                                max = range.year[2], 
                                                value = range.year)),
                       tableOutput("q4.table"), p(strong("Linear Regression")), 
                       textOutput("fit.intro"), p(""), plotOutput("q4.plot"),
                       textOutput("fit.description"), p(""), 
                       plotOutput("new.plot"), textOutput("new.description"),
                       p(""), p(strong("Conclusion")), 
                       textOutput("conclusion"), p(""), 
                       p(strong("Implications")), textOutput("implications"))
  )
  
)