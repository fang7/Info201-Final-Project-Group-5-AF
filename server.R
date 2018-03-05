library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

source("CleanMeteoriteData.R")
source("Question4Data.R")

meteorite.data <- CleanMeteoriteData()

q4.data <- RatioByYearData()

server <- function(input, output) {

  output$q4 <- renderText({
    "How has the amount of technology and/or resources helped observe 
    meteorite landngs over time? Has the amount of meteorites seen falling
    compared to the amount found on the ground increased over time?"
  })
  
  output$q4.table <- renderTable({
    return(q4.data)
  })  
  
  output$q4.plot <- renderPlot({
    p <- ggplot(q4.data) +
      geom_point(aes(x = year, y = percentage.fell)) +
      labs(title = "Percentage of Meteorites Seen Falling Over Time")
    return(p)
  })
}