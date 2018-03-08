library(dplyr)
  # Loads dplyr library

source("cleanMeteoriteData.R")
  # Gets the data from this r script

# Input: Takes no input.
# Function: Groups the meteorite data by year for meteorites that fell and 
#           meteorites that were found. Creates a new data frame with these 
#           counts and adds a column for the percentage of meteorites that were
#           seen falling.
# Output: Returns the data frame of the year, the number of meteorites seen 
#         falling, the number of meteorites found, and the percentage of 
#         meteorites seen falling.
RatioByYearData <- function() {
  
  meteorite.data <- CleanMeteoriteData()
  
  meteorite.data <- meteorite.data %>%
    filter(year <= 2011)
  
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
                                         
