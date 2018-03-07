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
<<<<<<< HEAD
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
=======
temp.pd <- population.density[, 1:44]
colnames(temp.pd) <- c('Country', 'yr1974','yr1975','yr1976','yr1977','yr1978','yr1979','yr1980','yr1981','yr1982','yr1983','yr1984','yr1985','yr1986','yr1987','yr1988',
                                  'yr1989','yr1990','yr1991','yr1992','yr1993','yr1994','yr1995','yr1996','yr1997','yr1998','yr1999','yr2000','yr2001','yr2002','yr2003','yr2004',
                                  'yr2005','yr2006','yr2007','yr2008','yr2009','yr2010','yr2011','yr2012','yr2013','yr2014','yr2015','yr2016')

#colnames(temp.pd) <- paste0('yr',colnames(temp.pd))

countries <- map_data("world")
#relevant <- select(temp.pd, 'Country', '1995') %>%
#  na.omit()
both_data <- left_join(countries, temp.pd, by = c("region" = "Country"))
# na.omit()
#both_data <- select(both_data, 'long', 'lat', 'region', '1995')

#year <- 1995

year2 <- '1995'

year <- rlang::sym(year2)

choosen <- select(both_data, long, lat, region, (!!year))




#check.meteorite.data <- mutate(meteorite.data, Country = GetCountryAtPoint(reclat, reclong))
#small_join <- left_join(check.meteorite.data, population.density, by = c("Country" = "Country"))

#countries <- map_data("world")
>>>>>>> sherley


#check.country.join <- left_join(countries, check.meteorite.data, by = c("region" = "Country"))
#big_join <- left_join(check.country.join, population.density, by = c("region" = "Country"))




# doesn;t seem to work
#meteorite.join.country <- right_join(countries, meteorite.data, by = c("lat" = "reclat", "long" = "reclong"))



# doesn;t seem to work
#meteorite.join.country <- right_join(countries, meteorite.data, by = c("lat" = "reclat", "long" = "reclong"))
