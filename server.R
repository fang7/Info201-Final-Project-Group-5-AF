library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(leaflet)
library(magrittr)

source('spatial_utils.R')
source("CleanMeteoriteData.R")

meteorite.data <- CleanMeteoriteData()

population.density <- read.csv("data/world_population.csv", 
                               stringsAsFactors = FALSE)
temp.pd <- population.density[, 1:44]
colnames(temp.pd) <- c('Country', '1974','1975','1976','1977','1978','1979','1980','1981','1982','1983','1984','1985','1986','1987','1988',
                       '1989','1990','1991','1992','1993','1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004',
                       '2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016')



server <- function(input, output) {
  
  output$map <- renderPlot({
    
    g <- ggplot(data = meteorite.data, mapping = aes(x = reclong, y = reclat)) +
      geom_point()
    
    countries <- map_data("world")
    both_data <- left_join(countries, temp.pd, by = c("region" = "Country"))
    
    breaks <- c(0.00, 5.00, 10.00, 15.00, 20.00, 25.00, Inf)
    
    meteorite.data <- filter(meteorite.data, year == input$n)
    
    p <- ggplot() + 
      geom_polygon(data = both_data, aes(x = long, y = lat, group = group, fill = cut(input$n, breaks = breaks)),
                   color = "black") + 
      scale_color_brewer(palette = 'Greys') +
      coord_quickmap() + 
      geom_point(data = meteorite.data, mapping = aes(x = reclong, y = reclat), color="red")
    
    return(p)
    
  })
  
  output$info <- renderText({
    #which.col <- input$n
    countries <- map_data("world")
    both_data <- left_join(countries, temp.pd, by = c("region" = "Country"))
    choose <- filter(both_data, region == GetCountryAtPoint(input$plot_click$x, input$plot_click$y))# %>%
    #  select(region, !!(which.col))
    paste("Latitude = ", input$plot_click$x, "Longitude = ", input$plot_click$y
          , "Country = ", GetCountryAtPoint(input$plot_click$x, input$plot_click$y), "Population = ", choose[3, 7])
    #paste(choose[3, 2])
  })
  
  
}