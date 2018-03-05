library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

source('spatial_utils.R')

#meteorite.data <- source("CleanMeteoriteData.R")

#is.data.frame(meteorite.data)

#meteorite.data <- flatten(meteorite.data)

complete.meteorite.data <- read.csv("data/meteorite-landings.csv", 
                                    stringsAsFactors = FALSE)
population.density <- read.csv("data/world_population.csv", 
                               stringsAsFactors = FALSE)
colnames(population.density) <- c('Country', '1755','1760','1765','1770','1775','1780','1785','1790','1795','1800','1805','1810','1815','1820','1825',
                                  '1830','1835','1840','1845','1850','1855','1860','1865','1870','1875','1890','1895','1900','1905','1910','1915',
                                  '1920','1925','1930','1935','1940','1945','1950','1955','1960','1965','1970','1975','1980','1985','1990','1995',
                                  '2000','2005','2010','2015')

meteorite.data <- complete.meteorite.data %>%
  filter(year >= 860 & year <= 2016) %>% 
  # filter out weird years 
  filter(reclong <= 180 & reclong >= -180 & (reclat != 0 | reclong != 0)) %>%
  # filter out weird locations
  filter(mass != 0.00)

#

#check.meteorite.data <- mutate(meteorite.data, Country = GetCountryAtPoint(reclat, reclong))
#small_join <- left_join(check.meteorite.data, population.density, by = c("Country" = "Country"))

#countries <- map_data("world")


#check.country.join <- left_join(countries, check.meteorite.data, by = c("region" = "Country"))
#big_join <- left_join(check.country.join, population.density, by = c("region" = "Country"))




# doesn;t seem to work
#meteorite.join.country <- right_join(countries, meteorite.data, by = c("lat" = "reclat", "long" = "reclong"))
