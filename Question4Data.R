library(dplyr)
source("cleanMeteoriteData.R")

RatioByYearData <- function() {
  
  meteorite.data <- CleanMeteoriteData()
  
  FellByYear <- meteorite.data %>%
    filter(fall == "Fell") %>%
    group_by(year) %>%
    summarise("fell" = n())
  
  FoundByYear <- meteorite.data %>%
    filter(fall == "Found") %>%
    group_by(year) %>%
    summarise("found" = n())
  
  RatioByYear <- left_join(FoundByYear, FellByYear)
  RatioByYear[32, "fell"] <- 0
  
  RatioByYear$percentage.fell <- 
    round(100 * RatioByYear$fell / (RatioByYear$found + RatioByYear$fell), 2)
  
  return(RatioByYear)
}
                                         
