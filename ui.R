library(shiny)

source("CleanMeteoriteData.R")

ui <- fluidPage(
  
  titlePanel(""),
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Q2"),
              tabPanel("Relation between meteorite data and population density", br(), p(textOutput("intro3")),
                       plotOutput("map3", click = "plot_click"),
                       verbatimTextOutput("info3"), sliderInput("n",
                                                       "Choose a year:",
                                                       value = 2000,
                                                       min = 1974,
                                                       max = 2016)
              ),
              tabPanel("Q4")
  )
  
)