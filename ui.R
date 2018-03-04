library(shiny)

source("CleanMeteoriteData.R")

ui <- fluidPage(
  
  titlePanel(""),
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Q2"),
              tabPanel("Relation between meteorite data and population density", plotOutput("map", click = "plot_click"),
                       textOutput("info")),
              tabPanel("Q4")
  )
  
)