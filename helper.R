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
colnames(temp.pd) <- c('Country', '1974','1975','1976','1977','1978','1979','1980','1981','1982','1983','1984','1985','1986','1987','1988',
                                  '1989','1990','1991','1992','1993','1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004',
                                  '2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016')



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
