library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

source("CleanMeteoriteData.R")
source("Question4Data.R")

meteorite.data <- CleanMeteoriteData()

server <- function(input, output) {

  output$q4 <- renderText({
    "How has the amount of technology and/or resources helped observe 
    meteorite landngs over time? Has the amount of meteorites seen falling
    compared to the amount found on the ground increased over time?"
  })
  
  output$ratio.table <- renderTable({
    
  })  
  
}