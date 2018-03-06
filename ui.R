library(shiny)

source("CleanMeteoriteData.R")

ui <- fluidPage(
  
  titlePanel(""),
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Q2"),
              tabPanel("Relation between meteorite data and population density", plotOutput("map", click = "plot_click"),
                       textOutput("info"), sliderInput("n",
                                                       "Choose a year:",
                                                       value = 2000,
                                                       min = 1974,
                                                       max = 2016)
              ),
              tabPanel("Q4")
  )
  
)