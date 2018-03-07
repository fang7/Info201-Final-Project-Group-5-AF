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


#check.country.join <- left_join(countries, check.meteorite.data, by = c("region" = "Country"))
#big_join <- left_join(check.country.join, population.density, by = c("region" = "Country"))




# doesn;t seem to work
#meteorite.join.country <- right_join(countries, meteorite.data, by = c("lat" = "reclat", "long" = "reclong"))



# doesn;t seem to work
#meteorite.join.country <- right_join(countries, meteorite.data, by = c("lat" = "reclat", "long" = "reclong"))
