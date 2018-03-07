library(dplyr)   # Loads the dplyr library needed for cleaning data

# Input: There is no input.
# Function: Reads the meteorite dataset downloaded from Kaggle and filters out
#           the rows with years before 680 and after 2016, with locations with
#           a valid latitude and longitude, and with a mass not equal to zero.
# Output: Returns the dataset of the cleaned meteorite dataset.
CleanMeteoriteData <- function() {
  complete.meteorite.data <- read.csv("data/meteorite-landings.csv", 
                                      stringsAsFactors = FALSE)
                           # Reads the data downloaded from Kaggle
  
  meteorite.data <- complete.meteorite.data %>%
    #filter(year >= 1974 & year <= 2011) %>% 
           # filter out weird years and years with small number of observations
    filter(year >= 1974 & year <= 2016) %>% 
                # filter out weird years and years with small number of observations
    filter(reclong <= 180 & reclong >= -180 & (reclat != 0 | reclong != 0)) %>%
           # filter out weird locations
    filter(mass != 0.00)
           # filter out unknown masses
  
  return(meteorite.data)
}