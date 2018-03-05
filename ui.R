library(shiny)

ui <- fluidPage(
  
  titlePanel("Exploring Meteorite Data"),
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Q2"),
              tabPanel("Q3"),
              tabPanel("Resources for Recording Meteorites", 
                       p(strong("Question 4:")), textOutput("q4"), 
                       tableOutput("ratio.table"))
  )
  
)