library(shiny)
library(rsconnect)

source("CleanMeteoriteData.R")
source("ui.R")
source("server.R")

shinyApp(ui, server)