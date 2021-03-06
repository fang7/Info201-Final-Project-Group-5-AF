library(shiny)
library(ggplot2)
library(rsconnect)
library(dplyr)
library(maps)
library(sp)
library(maptools)
library(RColorBrewer)

source('spatial_utils.R')
source("CleanMeteoriteData.R")

# Gets the functions for question 4 from this script
source("Question4Data.R")
  
# loads the data from the CleanMeteoriteData script
meteorite.data <- CleanMeteoriteData()

# reads in the data contanining information about population density
population.density <- read.csv("data/world_population.csv", 
                               stringsAsFactors = FALSE)
# selects the columns with data 1974 - 2016
temp.pd <- population.density[, 1:44]

# sets the column names to a more usable format
colnames(temp.pd) <- c('Country', 'yr1974','yr1975','yr1976','yr1977','yr1978',
                       'yr1979','yr1980','yr1981','yr1982','yr1983','yr1984',
                       'yr1985','yr1986','yr1987','yr1988','yr1989','yr1990',
                       'yr1991','yr1992','yr1993','yr1994','yr1995','yr1996',
                       'yr1997','yr1998','yr1999','yr2000','yr2001','yr2002',
                       'yr2003','yr2004','yr2005','yr2006','yr2007','yr2008',
                       'yr2009','yr2010','yr2011','yr2012','yr2013','yr2014',
                       'yr2015','yr2016')

# loads in the data about the countries geographic locatios and merges them 
# with the data set containing info about population density.
countries <- map_data("world")
both_data <- left_join(countries, temp.pd, by = c("region" = "Country"))

# Gets the data for question 4
q4.data <- RatioByYearData()
  

server <- function(input, output) {

  # Question 4 in text
  output$q4 <- renderText({
    "How has the amount of technology and/or resources helped observe 
    meteorite landngs over time? Has the amount of meteorites seen falling
    compared to the amount found on the ground increased over time?"
  })
  
  # A text description of the details of the table
  output$table.description <- renderText({
    "This table displays the number of meteorites found, the number of 
    meteorites seen falling, and the percentage of meteorites seen falling for 
    the user-selected years. This table also displays the averages for all of 
    these values over the selected time period as the last row in the table."
  })
  
  output$slider.info <- renderText({
    "This slider only affects the table data and the averages. The data used  
    in the linear regression is not affected."
  })
  
  # Filters the data to only include the time period the user selects
  filtered.years <- reactive({q4.data %>%
                                filter(year >= input$year.choice[1] &
                                       year <= input$year.choice[2])
  })
  
  # Gets the mean of the number of meteorites found, the number of meteorites 
  # seen falling, and the percentage of meteorites seen falling for the
  # selected time period
  mean.found <- reactive({round(mean(filtered.years()$found), 2)})
  mean.fell <- reactive({round(mean(filtered.years()$fell), 2)})
  mean.percentage <- 
    reactive({round(100 * mean.fell() / (mean.fell() + mean.found()), 2)})
  
  # Adds the averages to the bottom of the table
  filtered.data <- 
    reactive({rbind(filtered.years(), c("Averages", mean.found(), mean.fell(),
                                        mean.percentage()))})
  
  # The data for question for as a table
  output$q4.table <- renderTable({
    return(filtered.data())
  })  
  
  # An introduction to what linear regression will be done
  output$fit.intro <- renderText({
    "Here we are going to fit a linear regression line for the relationship 
    between the year and the percentage of meteorites seen falling. We will 
    use every year in the data set (1974-2011) for this analysis."
  })
  
  # The linear fit for the percentage of meteorites seen falling vs the year
  linear.fit <- lm(q4.data$percentage.fell ~ q4.data$year)
  
  # A plot of the percentage of meteorites seen falling vs the year with the 
  # linear regression line fitted, the slope, and the correlation coefficient
  # on the plot.
  output$q4.plot <- renderPlot({
    p <- ggplot(q4.data, mapping = aes(x = year, y = percentage.fell)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      geom_text(x = 2007, y = 7, 
                label = paste("r =", 
                              round(cor(q4.data$year, q4.data$percentage.fell),
                                    2))) +
      geom_text(x = 2007, y = 8, 
                label = paste("slope =", 
                              round(summary(linear.fit)$coefficients[2,1], 
                                    2))) +
      labs(title = "Percentage of Meteorites Seen Falling Over Time")
    return(p)
  })
  
  # A text description of the linear fit    
  output$fit.description <- renderText({
    paste0("The linear fit has a slope of ", 
          round(summary(linear.fit)$coefficients[2,1], 2), " and an associated 
          p-value of ", round(summary(linear.fit)$coefficients[2,4], 2), ". The
           correlation coefficient is r = ", 
          round(cor(q4.data$year, q4.data$percentage.fell), 2), ". Both values 
          are negative which means that the number of meteorites seen falling 
          is actually trending downward. The p-value is not significant and 
          the correlation coefficient is quite low so therefore the 
          downward trend doesn't seem significant. This could be because of 
          the outlier data of 20% during the year 1976. Let's see what happens 
          when we remove any outliers by getting rid of years with residuals 
          greater than 10.")
  })
    
  # Removes the outliers (residuals greater than 10 was threshold)
  q4.new.data <- q4.data[-which(abs(linear.fit$residuals) > 10), ]
    
  # The linear fit for the percentage of meteorites seen falling vs the year
  # but without the outliers
  new.linear.fit <- lm(q4.new.data$percentage.fell ~ q4.new.data$year)
    
  # A plot of the percentage of meteorites seen falling vs the year with the 
  # linear regression line fitted, the slope, and the correlation coefficient
  # on the plot but this time without the outliers.
  output$new.plot <- renderPlot({
      p2 <- ggplot(q4.new.data, mapping = aes(x = year, y = percentage.fell)) +
         geom_point() +
         geom_smooth(method = "lm", se = FALSE) +
         geom_text(x = 2010, y = 2, 
                  label = paste("r =", 
                                round(cor(q4.new.data$year, 
                                          q4.new.data$percentage.fell), 2))) +
         geom_text(x = 2010, y = 2.2, 
                   label = paste("slope =", 
                               round(summary(new.linear.fit)$coefficients[2,1],
                                     3))) +
         labs(title = "Percentage of Meteorites Seen Falling Over Time")
      return(p2)
  })
  
  # A text description of the linear fit without the outliers
  output$new.description <- renderText({
    paste0("After removing outliers, the new slope of the linear regression 
           line is ", round(summary(new.linear.fit)$coefficients[2,1], 3), 
           " with an associated p-value of ", 
           round(summary(new.linear.fit)$coefficients[2,4], 2), ". The 
           correlation coefficient is r = ", 
           round(cor(q4.new.data$year, q4.new.data$percentage.fell), 2), ". 
           Both of these values still indicate a extremely small downward trend 
           but it is much closer to zero. This would mean that there is no 
           change in percentage of meteorites seen falling over time. These 
           results are not significant as the p-value is much larger than 0.05 
           and the correlation coefficient is extremely low.") 
  })
  
  # A conclusion of the results of the analysis
  output$conclusion <- renderText({
    paste0("The linear fit regression line originally had a slope of ", 
           round(summary(linear.fit)$coefficients[2,1], 2), " and a correlation
           coefficient of ", 
           round(cor(q4.data$year, q4.data$percentage.fell), 2), ". This 
           wouldn't really make sense as the percentage of meteorites seen 
           falling shouldn't be decreasing over time as technology improves 
           unless NASA and/or observatories lost funding. Therefore, I decided 
           to remove outliers and fit another linear regression line. This new 
           regression line had a slope of ", 
           round(summary(new.linear.fit)$coefficients[2,1], 3), " with an 
           associated p-value of ", 
           round(summary(new.linear.fit)$coefficients[2,4], 2), " and a 
           correlation coefficient of ", 
           round(cor(q4.new.data$year, q4.new.data$percentage.fell), 2), " . 
           This slope seems more likely as it is very close to zero so that 
           would mean that the percentage of meteorites seen falling has 
           remained constant over time. Unfortunately, the p-value is too large
           and the correlation coefficient is too low to deem this result 
           significant. In conclusion, the percentage of meteorites seen 
           falling over time seems to remain somewhat constant, but the results
           were quite random and not significant.")
  })
  
  # The implications of the results of this analysis
  output$implications <- renderText({
    "You should be interested in these results for two reasons. One, they show 
    that meteorites observed falling are basically observed at random. Two, 
    they show that there have been no improvements in technology used to 
    observe meteorites as they're falling. If you want to work for NASA or 
    a related company, or you just are interested in meteorites, you could 
    design technology that would detect or predict meteorites and it will  
    almost certainly be an improvement."
  })

  output$map3 <- renderPlot({
    
    breaks <- c(0.00, 10.00, 20.00, 30.00, 40.00, 50.00, Inf)
    meteorite.data <- filter(meteorite.data, year == input$n)
    
    # makes a map that shows the population density distibution for the 
    # selected year and also diplays the meteorites that fell at different
    # parts of the world in that year.
    p <- ggplot() + 
      geom_polygon(data = both_data, 
                   aes(x = long, y = lat, group = group, 
                       fill = cut(both_data[[paste0('yr', input$n)]], 
                                  breaks = breaks)),
                   color = "black") + 
      scale_fill_brewer(palette = "Green") +
      coord_quickmap() + 
      geom_point(data = meteorite.data, mapping = aes(x = reclong, y = reclat),
                 color="red") +
      guides(fill=guide_legend(title = "Population density in residents per 
                               square mile"))
    return(p)
  })
  
  # prints out information depending upon the place on the map clicked by the 
  # user
  output$info3 <- renderText({
    choosen <- filter(both_data, region == 
                        GetCountryAtPoint(input$plot_click$x, 
                                          input$plot_click$y)) %>%
      select(region, paste0('yr', input$n))
    
    # prints out data depending on the region of map clicked by the user.
    paste0("Click map to display information:","\nLatitude = ", 
           input$plot_click$x, "\nLongitude = ", input$plot_click$y
          , "\nCountry = ", GetCountryAtPoint(input$plot_click$x, 
                                              input$plot_click$y), 
          "\nPopulation = ", round(choosen[3, 2], 2), " residents per square 
          mile ")
  })
  
  # prints an introduction to the map used in the third analysis question
  output$intro3 <- renderText({
    paste0("This map represents the population density distribution across the
            world over different years. The red dots represent locations at 
            which meteorite falls have been recorded in the respective years.
            The map can be clicked for further information about the location 
            and its population density.")
  })
  
  #-------------------------------------------------------------------------
  # PART 2
  #-------------------------------------------------------------------------
  
  # READING DATA IN
  meta.data <- read.csv('data/meteorite-landings.csv')
  
  # FILTER RELEVANT YEARS DATA AND GETTING COUNTRY NAMES
  meta.data <- meta.data %>%
    filter(year >= 1974 & year <= 2011) %>%
    na.omit() %>%
    mutate(region = GetCountryAtPoint(reclat,reclong))
  
  # Density Map OVERALL COUNTS OF METEORS
  total.counts <- reactive({
    
    count.region <- meta.data %>%
      filter(year == input$select.year) %>%
      group_by(region) %>%
      summarize(counts = n()) %>%
      arrange(desc(counts)) %>%
      na.omit() 
    
    return(count.region)
  })
  
  # Composition table for the BARPLOT
  make.three <- reactive({
    
    meta.data <- meta.data %>%
      filter(year == input$select.year) %>%
      group_by(recclass,region) %>%
      summarize(counts = n()) %>%
      na.omit() %>%
      arrange(desc(counts))
    
    return(meta.data)
  })
  
  # DATA FOR METEORITE TYPE COUNTS BY REGION (LAND ONLY)
  map.data <- reactive({
    
    # find out the region
    world.data <- map_data("world")
    mr.world.wide <- left_join(world.data, total.counts(), by = "region")
    mr.world.wide$counts[is.na(mr.world.wide$counts)] <- 0
    
    return(mr.world.wide)
  })
  
  # DENSITY PLOT ON MAP
  # ----------------------------------------------------------------------- 
  output$q2.map <- renderPlot({
    
    plot <- ggplot(data = map.data()) +
      geom_polygon(aes(x = long, y = lat, group = group, fill = 
                         cut(counts, breaks = c(0,1,2,5,10,Inf), 
                             labels = c("1","2-3","4-5","6-10","10+"))), 
                   color = "black") + 
      scale_fill_brewer(palette = "Reds") +
      coord_quickmap()  + 
      guides(fill=guide_legend(title="Impact Zone Frequency Levels"))
    
    return(plot)
  })
  
  # BARPLOT BELOW MAP
  # -----------------------------------------------------------------------
  output$q2.bar.graph <- renderPlot({
    plot <- ggplot(data = make.three(), aes(y = counts, x = region
                                            , fill = recclass)) + 
      geom_bar(stat="identity") + 
      labs(x = "Country", y = "Number of Meteors")   + 
      guides(fill=guide_legend(title="Classification"))
    
    return(plot)
  })
  
  # SUMMARY AND INTERACTIVE DATA
  # -----------------------------------------------------------------------
  output$q2.text2 <- renderText({
    "After analyzing the graph and barplot we can conclude there is no exact
    trend to where the meteorites fall. There are years where there are 
    significantly more data collected in areas like Poland, Lithuania, and
    Saudi Arabia. But none of it is significant enough information to actually
    determine a pattern. As far as composition goes the distribution of types
    that have fallen in these more common places in any given year is rather 
    fair."
    
  })
  
  # Rendering info tree
  output$img.source <- renderText({
    "Source: https://commons.wikimedia.org/wiki/File:Meteorite_Classification
    _after_Weissberg_McCoy_Krot_2006_Stony_Iron.svg"
  })
  
  # Description
  output$q2.text3 <- renderText({
    " Below is a study on if certain compositions of meteorites fall more
      commonly in specific areas than others. There is a map provided showing
      the heat zones for meteor strikes during the current year selected for 
      an overall view of the data we are working with. Underneath is a bargraph
      that breaks down the total count of meteorites per region into their 
      classification groups one color for each group present. A tree and table
      are provided for information on classification conventions for general 
      curiosity."
  })
  
  #-------------------------------------------------------------------------
  # PART 1
  #-------------------------------------------------------------------------
  complete.meteorite.data <- read.csv("data/meteorite-landings.csv", 
                                      stringsAsFactors = FALSE)
  
  # Reads the data downloaded from Kaggle
  meta.data.q1 <- complete.meteorite.data %>%
    filter(year >= 1974 & year <= 2016) %>% 
    filter(reclong <= 180 & reclong >= -180 & (reclat != 0 | reclong != 0)) %>%
    filter(mass != 0.00) %>%
    select(-nametype) 
  
  # filters map with the chosen year
  new.map.q1 <- reactive({
    map.info.q1 <- meta.data.q1 %>%
      filter(year == input$chosen.year)
    return(map.info.q1)
  })
  
  # grabs the world map data and returns it 
  world.map.q1 <- reactive({
    world.map.q1 <- map_data("world") 
    return(world.map.q1)
  })
  
  # plots red points of where the meteorites have fallen and includes a map
  # visualization to show where in the world the meteorite has fallen
  output$plot <- renderPlot({
    plot <-ggplot(data = new.map.q1(), mapping = aes(x = reclong, y = reclat), 
                  color = "red") +
      geom_point() +
      geom_polygon(data = world.map.q1(), mapping=aes(x=long, y=lat, group=group),
                   color = "black") +
      coord_quickmap() +
      geom_point(data = new.map.q1(), mapping = aes(x = reclong, y = reclat), 
                 color = "red")
    return(plot)
  })
  
  # filters unneccesary information from the data frame and returns it
  filtered.map.q1 <- reactive({
    filitered.info.q1 <- new.map.q1() %>%
      select(-id) %>%
      select(-year)
    return(filitered.info.q1)
  })
  
  # returns info about nearest points when clicking on certain parts of the map
  output$click_info <- renderPrint({
    nearPoints(filtered.map.q1(), input$plot_click, addDist = TRUE)
  })
  
  # allows the user to click and drag to grab a bunch of plotted points and 
  # returns all the information about them
  output$brush_info <- renderPrint({
    brushedPoints(filtered.map.q1(), input$plot_brush)
  })
  
  output$map.description <- renderText({
    map.description <- paste0("Below shows the world map with different
                              locations of meteorites that have landed on Earth. 
                              The map is currently displaying the year: ", 
                              input$chosen.year, ". Click your mouse on the
                              plot (and wait two seconds!) to find information 
                              including name, class, mass, if it fell, and
                              the geolocation coordinates. You can click and 
                              brush over several points to display more info.")
    return(map.description)
  })
}

shinyServer(server)

