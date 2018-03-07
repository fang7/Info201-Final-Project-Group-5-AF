library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(leaflet)
library(magrittr)
library(RColorBrewer)

source('spatial_utils.R')
source("CleanMeteoriteData.R")

meteorite.data <- CleanMeteoriteData()

population.density <- read.csv("data/world_population.csv", 
                               stringsAsFactors = FALSE)
temp.pd <- population.density[, 1:44]
colnames(temp.pd) <- c('Country', 'yr1974','yr1975','yr1976','yr1977','yr1978',
                       'yr1979','yr1980','yr1981','yr1982','yr1983','yr1984',
                       'yr1985','yr1986','yr1987','yr1988','yr1989','yr1990',
                       'yr1991','yr1992','yr1993','yr1994','yr1995','yr1996',
                       'yr1997','yr1998','yr1999','yr2000','yr2001','yr2002',
                       'yr2003','yr2004','yr2005','yr2006','yr2007','yr2008',
                       'yr2009','yr2010','yr2011','yr2012','yr2013','yr2014',
                       'yr2015','yr2016')

countries <- map_data("world")
both_data <- left_join(countries, temp.pd, by = c("region" = "Country"))


server <- function(input, output) {
  
  output$map3 <- renderPlot({
    
    breaks <- c(0.00, 10.00, 20.00, 30.00, 40.00, 50.00, Inf)
    meteorite.data <- filter(meteorite.data, year == input$n)
    
    fill=guide_legend(title="Impact Zone Frequency Levels")
    
    p <- ggplot() + 
      geom_polygon(data = both_data, aes(x = long, y = lat, group = group, fill = cut(both_data[[paste0('yr', input$n)]], breaks = breaks)),   #both_data[[paste0('yr', input$n)]]),
                   color = "black") + 
      scale_fill_brewer(palette = "Green") +
      coord_quickmap() + 
      geom_point(data = meteorite.data, mapping = aes(x = reclong, y = reclat), color="red") +
      guides(fill=guide_legend(title="Population density in residents per square mile"))
    
    return(p)
    
  })
  
  output$info3 <- renderText({
    choosen <- filter(both_data, region == GetCountryAtPoint(input$plot_click$x, input$plot_click$y)) %>%
      select(region, paste0('yr', input$n))
    paste0("Click map to display information:","\nLatitude = ", input$plot_click$x, "\nLongitude = ", input$plot_click$y
          , "\nCountry = ", GetCountryAtPoint(input$plot_click$x, input$plot_click$y), "\nPopulation = ", choosen[3, 2],
          " residents per square mile ")
  })
  
  output$intro3 <- renderText({
    paste0("This map represents the population density distribution across the world over different years. The red dots represent
           locations at which meteorite falls have been recorded in the respective years. The map can be clicked for further 
           information about the location and its population density.")
  })
}
shinyServer(server)