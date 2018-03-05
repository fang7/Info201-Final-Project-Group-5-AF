library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

source('spatial_utils.R')
source("CleanMeteoriteData.R")

meteorite.data <- CleanMeteoriteData()

population.density <- read.csv("data/world_population.csv", 
                               stringsAsFactors = FALSE)
colnames(population.density) <- c('Country', '1755','1760','1765','1770','1775','1780','1785','1790','1795','1800','1805','1810','1815','1820','1825',
                                  '1830','1835','1840','1845','1850','1855','1860','1865','1870','1875','1890','1895','1900','1905','1910','1915',
                                  '1920','1925','1930','1935','1940','1945','1950','1955','1960','1965','1970','1975','1980','1985','1990','1995',
                                  '2000','2005','2010','2015')
#population.density <- read.csv()

server <- function(input, output) {
  
  output$map <- renderPlot({
    
    check.meteorite.data <- mutate(meteorite.data, Country = GetCountryAtPoint(reclat, reclong))
    small_join <- left_join(check.meteorite.data, population.density, by = c("Country" = "Country"))
    
    #meteorite.country <- mutate(d(), Country = GetCountryAtPoint(reclat, reclong))
    
    #breaks <- c()
    
    p <- ggplot(data = check.meteorite.data) +
      geom_polygon(aes(x = reclat, y = reclong, group = group), #, fill = 
                         #cut(d(), breaks = breaks, labels = label)), 
                   color = "black") + 
      scale_color_brewer(palette = 'Greys') +
      coord_quickmap() 
    
    return(p)
  
  })
  
}